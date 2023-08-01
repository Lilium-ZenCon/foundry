// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {Proof} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {HardwareData} from "@libraries/storage/HardwareData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICartesiDApp} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {TransactionData} from "@libraries/storage/TransactionData.sol";
import {IEtherPortal} from "@cartesi/contracts/portals/IEtherPortal.sol";
import {IERC20Portal} from "@cartesi/contracts/portals/IERC20Portal.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";

contract Company is AccessControl {
    // create this enum in a new file and import it
    enum State {
        HAPPENING,
        FINALIZED
    }

    State public auctionState = State.FINALIZED;

    CompanyData.Company public company;
    HardwareData.Hardware public hardware;

    bytes32 constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant HARDWARE_ROLE = keccak256("HARDWARE_ROLE");
    bytes32 constant AUCTION_ROLE = keccak256("AUCTION_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    error AuctionHappening();
    error AuctionNotHappening();
    error Unouthorized(address _sender);
    error DontHaveAllowance(uint256 _amount);
    error InsufficientAmount(uint256 _amount);
    error InvalidAmountPercentage(uint8 _amountPercentage);

    constructor(
        string memory _cid,
        string memory _name,
        address _token,
        string memory _country,
        string memory _industry,
        uint256 _allowance,
        uint256 _compensation,
        address _agent,
        address _hardwareAddress,
        address _priceFeedContractsAddress
    ) {
        company.cid = _cid;
        company.name = _name;
        company.token = _token;
        company.country = _country;
        company.industry = _industry;
        company.allowance = _allowance;
        company.compensation = _compensation;
        company.cartesiAuction = address(0);
        company.cartesiInputBox = address(0);
        company.cartesiVerifier = address(0);
        company.cartesiERC20Portal = address(0);
        company.cartesiEtherPortal = address(0);
        company.parityRouter = address(0);
        company.agents[address(this)].push(_agent);
        company.hardwareDevices[address(this)].push(_hardwareAddress);
    }

    function setupAuxiliarContracts(
        address _cartesiAuction,
        address _cartesiInputBox,
        address _cartesiVerifier,
        address _cartesiERC20Portal,
        address _cartesiEtherPortal,
        address _priceFeed
    ) public {
        company.cartesiAuction = _cartesiAuction;
        company.cartesiInputBox = _cartesiAuction;
        company.cartesiVerifier = _cartesiVerifier;
        company.cartesiERC20Portal = _cartesiERC20Portal;
        company.cartesiEtherPortal = _cartesiEtherPortal;
        company.parityRouter = _priceFeed;
    }

    function quoteParity() public view returns (int256) {
        (, int price, , , ) = AggregatorV3Interface(company.parityRouter)
            .latestRoundData();
        return price / 1e8;
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function transactionHistory()
        external
        view
        returns (TransactionData.Transaction[] memory)
    {
        return company.transactionHistory[address(this)];
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function addHardwareDevice(address _hardwareAddress) public onlyRole(AGENT_ROLE) {
        company.hardwareDevices[address(this)].push(_hardwareAddress);
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function gethardwareDevices() external view returns (address[] memory) {
        return company.hardwareDevices[address(this)];
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function verificationHistory()
        external
        view
        returns (HardwareData.Hardware[] memory)
    {
        return company.verificationHistory[address(this)];
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function addAgent(address _agent) public onlyRole(AGENT_ROLE) {
        company.agents[address(this)].push(_agent);
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function getagents() external view returns (address[] memory) {
        return company.agents[address(this)];
    }

    function increaseAllowance(uint256 _amount) external onlyRole(VERIFIER_ROLE) {
        company.allowance += _amount;
    }

    function decreaseAllowance(uint256 _amount) private {
        company.allowance -= _amount;
    }

    function verifyRealWorldState(
        address _InputBox,
        bytes memory _RealWorldData
    ) public onlyRole(HARDWARE_ROLE){
        bytes memory _payload = abi.encodePacked(_RealWorldData);
        IInputBox(_InputBox).addInput(company.cartesiVerifier, _payload);
        HardwareData.Hardware({
            hardwareAddress: msg.sender, 
            lastVerification: block.timestamp
        });
    }

    //event
    function newAuction(
        address _ERC20Portal,
        uint256 _amount,
        uint256 _duration,
        uint256 _reservePricePerToken
    ) public onlyRole(AGENT_ROLE){
        if (auctionState == State.HAPPENING) {
            revert AuctionHappening();
        } else {
            ICarbonCredit(company.token).allowance(msg.sender, _ERC20Portal);
            ICarbonCredit(company.token).approve(_ERC20Portal, _amount);
            bytes memory _newAuctionHash = abi.encode(
                _duration * 1 hours,
                _reservePricePerToken
            );
            IERC20Portal(_ERC20Portal).depositERC20Tokens(
                IERC20(company.token),
                company.cartesiAuction,
                _amount,
                _newAuctionHash
            );
        }
    }

    // event
    function newBid(
        address _EtherPortal,
        uint8 _amountPercentage
    ) public payable {
        if (_amountPercentage < 0 && _amountPercentage >= 100) {
            revert InvalidAmountPercentage(_amountPercentage);
        } else if (auctionState != State.HAPPENING) {
            revert AuctionNotHappening();
        } else {
            bytes memory _executeLayerData = abi.encode(
                _amountPercentage
            );
            IEtherPortal(_EtherPortal).depositEther(
                company.cartesiAuction,
                _executeLayerData
            );
        }
    }

    function finalizeAuction() public onlyRole(AGENT_ROLE){
        IInputBox(company.cartesiAuction).addInput(
            company.cartesiAuction,
            abi.encodePacked(msg.sig)
        );
    }

    // event
    function executeVerifierVoucher(
        bytes memory _payload,
        Proof memory _proof
    ) public {
        ICartesiDApp(company.cartesiVerifier).executeVoucher(
            company.cartesiVerifier,
            _payload,
            _proof
        );
    }

    // event
    function executeAuctionVoucher(
        bytes memory _payload,
        Proof memory _proof
    ) public {
        ICartesiDApp(company.cartesiAuction).executeVoucher(
            company.cartesiAuction,
            _payload,
            _proof
        );
    }

    // event
    function mint(uint256 _amount) public onlyRole(AGENT_ROLE){
        if (company.agents[msg.sender] != true) {
            revert Unouthorized(msg.sender);
        } else {
            ICarbonCredit(company.token).mint(msg.sender, _amount);
            company.transactionHistory[address(this)].push(
                TransactionData.Transaction({
                    buyer: msg.sender,
                    amount: _amount,
                    identifier: msg.sig,
                    timestamp: block.timestamp,
                    company: address(this)
                })
            );
            decreaseAllowance(_amount);
        }
    }

    // event
    function retire(uint256 _amount) public {
        // if(IERC20(company.token).balanceOf(msg.sender) < _amount){
        //     revert 
        // }
        ICarbonCredit(company.token).burn(msg.sender, _amount);
        company.transactionHistory[address(this)].push(
            TransactionData.Transaction({
                buyer: msg.sender,
                amount: _amount,
                identifier: msg.sig,
                timestamp: block.timestamp,
                company: address(this)
            })
        );
    }

    //withdraw

    //hardware:
    // - Assinautura
    // - hash
}
