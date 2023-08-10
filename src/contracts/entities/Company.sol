//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {Proof} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICartesiDApp} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {IEtherPortal} from "@cartesi/contracts/portals/IEtherPortal.sol";
import {IERC20Portal} from "@cartesi/contracts/portals/IERC20Portal.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IDAppAddressRelay} from "@cartesi/contracts/relays/IDAppAddressRelay.sol";

/**
 * @title Company
 * @notice This contract is a insterface to interact with verifier and auction cartesi machine, and other attributes of company
 */
contract Company is AccessControl {
    CompanyData.Company public company;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant AUCTION_ROLE = keccak256("AUCTION_ROLE");
    bytes32 constant HARDWARE_ROLE = keccak256("HARDWARE_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    error DontHaveSuficientAllowance(uint256 _amount);

    event Mint(address _sender, uint256 _amount);
    event NewBid(address _sender, uint256 _amount, uint8 _amountPercentage);
    event VerifierVoucherExecuted(
        address _sender,
        bytes _payload,
        Proof _proof
    );
    event AuctionVoucherExecuted(address _sender, bytes _payload, Proof _proof);
    event NewAuction(
        address _sender,
        uint256 _amount,
        uint256 _duration,
        uint256 _reservePricePerToken
    );

    constructor(
        string memory _cid,
        string memory _name,
        address _token,
        string memory _country,
        string memory _industry,
        uint256 _allowance,
        address _cartesiInputBox,
        address _cartesiERC20Portal,
        address _cartesiEtherPortal,
        address _cartesiCartesiDAppAddressRelay,
        uint256 _compensation,
        address _agent
    ) {
        company.cid = _cid;
        company.name = _name;
        company.token = _token;
        company.country = _country;
        company.industry = _industry;
        company.allowance = _allowance;
        company.cartesiInputBox = _cartesiInputBox;
        company.cartesiERC20Portal = _cartesiERC20Portal;
        company.cartesiEtherPortal = _cartesiEtherPortal;
        company
            .cartesiCartesiDAppAddressRelay = _cartesiCartesiDAppAddressRelay;
        company.compensation = _compensation;
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    /**
     * @notice Get Lilium URI
     * @dev This function get lilium URI using IPFS library
     * @return string URI
     */
    function getURI() public view returns (string memory) {
        return IPFS.getURI(company.cid);
    }

    /**
     * @notice Set Cartesi Certifier Contract
     * @dev This function set cartesi verifier and auction contract address after deploy, because it is not possible to set it before deploy since the cartesi machine is deployed later. In addition, it grant verifier and auction role to the contracts and send cartesi machine address to cartesi dapp via relay
     * @param _cartesiAuction address of cartesi auction contract
     * @param _cartesiVerifier address of cartesi verifier contract
     */
    function setAuxiliarContracts(
        address _cartesiAuction,
        address _cartesiVerifier
    ) public onlyRole(AGENT_ROLE) {
        company.cartesiAuction = _cartesiAuction;
        company.cartesiVerifier = _cartesiVerifier;
        _grantRole(VERIFIER_ROLE, _cartesiVerifier);
        _grantRole(AUCTION_ROLE, _cartesiAuction);
        IDAppAddressRelay(company.cartesiCartesiDAppAddressRelay)
            .relayDAppAddress(_cartesiVerifier);
        IDAppAddressRelay(company.cartesiCartesiDAppAddressRelay)
            .relayDAppAddress(_cartesiVerifier);
    }

    /**
     * @notice Increase allowance to mint token
     * @dev This function increase allowance to mint token. Only verifier cartesi machine can call this function
     * @param _amount amount of token to increase allowance
     */
    function increaseAllowance(
        uint256 _amount
    ) external onlyRole(VERIFIER_ROLE) {
        company.allowance += _amount;
    }

    /**
     * @notice Decrease allowance to mint token
     * @dev This function decrease allowance to mint token. This function is private because only mint function can call this function
     * @param _amount amount of token to decrease allowance
     */
    function decreaseAllowance(uint256 _amount) private {
        company.allowance -= _amount;
    }

    /**
     * @notice Add hardware device
     * @dev This function add hardware device address. Only agent can call this function
     * @param _hardwareAddress address of hardware device
     */
    function addHardwareDevice(
        address _hardwareAddress
    ) public onlyRole(AGENT_ROLE) {
        _grantRole(HARDWARE_ROLE, _hardwareAddress);
    }

    /**
     * @notice Verify real world state
     * @dev This function verify real world state. Only hardware device can call this function
     * @param _RealWorldData real world data. Which will be a json in bytes
     */
    function verifyRealWorldState(
        string memory _RealWorldData
    ) public onlyRole(HARDWARE_ROLE) {
        bytes memory _input = abi.encodePackedPacked(msg.sig, _RealWorldData);
        IInputBox(company.cartesiInputBox).addInput(
            company.cartesiVerifier,
            _input
        );
    }

    /**
     * @notice Execute verifier voucher
     * @dev This function execute verifier voucher.
     * @param _signature signature of verifier voucher
     * @param _proof proof of verifier voucher
     */
    function executeVerifierVoucher(
        bytes calldata _signature,
        Proof calldata _proof
    ) public {
        bytes memory _payload = abi.encodePacked(msg.sig, _signature);
        ICartesiDApp(company.cartesiVerifier).executeVoucher(
            company.cartesiVerifier,
            _payload,
            _proof
        );
        emit VerifierVoucherExecuted(msg.sender, _payload, _proof);
    }

    /**
     * @notice Mint token
     * @dev This function mint token (CarbonCredit) to an address verifying if the company has enough allowance and decrease allowance after mint token. Only agent can call this function
     * @param _amount amount of token to mint
     */
    function mint(uint256 _amount) public onlyRole(AGENT_ROLE) {
        if (company.allowance < _amount) {
            revert DontHaveSuficientAllowance(_amount);
        } else {
            decreaseAllowance(_amount);
            ICarbonCredit(company.token).mint(msg.sender, _amount);
            emit Mint(msg.sender, _amount);
        }
    }

    /**
     * @notice Auxiliar function to set auction duration
     * @dev This function set auction duration. It's private because only newAuction function can call this function
     * @param _duration duration of auction in hours
     */
    function setAuctionDuration(uint256 _duration) private {
        company.auctionDuration = _duration * 1 hours;
    }

    /**
     * @notice Create new auction
     * @dev This function create new auction. Only agent can call this function. In the process, the function gives permission for the ERC20Portal contract to transfer the wallet value from msg.sender to the cartesi dapp and then calls the ERC20Portal sending in addition to the value an _executelayerdata in bytes containing the duration of the auction and the _reservePricePerToken
     * @param _amount amount of token to auction
     * @param _duration duration of auction in hours
     * @param _reservePricePerToken reserve price per token
     */
    function newAuction(
        uint256 _amount,
        uint256 _duration,
        uint256 _reservePricePerToken
    ) public onlyRole(AGENT_ROLE) {
        IERC20(company.token).approve(company.cartesiERC20Portal, _amount);
        setAuctionDuration(_duration);
        bytes memory _execLayerData = abi.encodePacked(
            company.auctionDuration,
            _reservePricePerToken
        );
        IERC20Portal(company.cartesiERC20Portal).depositERC20Tokens(
            IERC20(company.token),
            company.cartesiAuction,
            _amount,
            _execLayerData
        );
        emit NewAuction(msg.sender, _amount, _duration, _reservePricePerToken);
    }

    /**
     * @notice Create new bid
     * @dev this function transfer an amount in ether to Auction Cartesi Machine calling EtherPortal contract sending in addition to the value an _executelayerdata in bytes containing the interestedQuantity of the amount offered
     * @param _interestedQuantity interested quantity of the amount offered
     */
    function newBid(uint256 _interestedQuantity) public payable {
        bytes memory _executeLayerData = abi.encodePacked(_interestedQuantity);
        IEtherPortal(company.cartesiEtherPortal).depositEther(
            company.cartesiAuction,
            _executeLayerData
        );
        emit NewBid(msg.sender, msg.value, _interestedQuantity);
    }

    /**
     * @notice Heartbeat to Auction Cartesi Machine
     * @dev This function send a heartbeat to Auction Cartesi Machine. This function is called by ChainLink Automation every 1 hour
     */
    function heartbeat() public {
        bytes memory _heartbeatData = abi.encodePacked(msg.sig);
        IInputBox(company.cartesiInputBox).addInput(
            company.cartesiAuction,
            _heartbeatData
        );
    }

    /**
     * @notice Withdraw from Auction Cartesi Machine
     * @dev This function executes the auction voucher to withdraw the respective values ​​according to the final state of the auction
     * @param _signature signature of auction voucher
     * @param _proof proof of auction voucher
     */
    function withdraw(bytes calldata _signature, Proof calldata _proof) public {
        bytes memory _payload = abi.encodePacked(msg.sig, _signature);
        ICartesiDApp(company.cartesiAuction).executeVoucher(
            company.cartesiAuction,
            _payload,
            _proof
        );
        emit AuctionVoucherExecuted(msg.sender, _payload, _proof);
    }
}
