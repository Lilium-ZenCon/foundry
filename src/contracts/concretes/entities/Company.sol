//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IPFS} from "@libraries/function/IPFS.sol";
import {AuctionState} from "@enums/AuctionState.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {Proof} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {HardwareData} from "@libraries/storage/HardwareData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICartesiDApp} from "@cartesi/contracts/dapp/ICartesiDApp.sol";
import {IEtherPortal} from "@cartesi/contracts/portals/IEtherPortal.sol";
import {IERC20Portal} from "@cartesi/contracts/portals/IERC20Portal.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";

contract Company is AccessControl {
    AuctionState public auctionState;

    CompanyData.Company public company;
    HardwareData.Hardware public hardware;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant AUCTION_ROLE = keccak256("AUCTION_ROLE");
    bytes32 constant HARDWARE_ROLE = keccak256("HARDWARE_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    error AuctionHappening();
    error AuctionNotHappening();
    error DontHaveSuficientAllowance(uint256 _amount);
    error WithdrawFailed(address _sender, uint256 _amount);
    error InvalidAmountPercentage(uint8 _amountPercentage);

    event FinishedAuction(address _sender);
    event Mint(address _sender, uint256 _amount);
    event Retire(address _sender, uint256 _amount);
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
        uint256 _compensation,
        address _agent
    ) {
        company.cid = _cid;
        company.name = _name;
        company.token = _token;
        company.country = _country;
        company.industry = _industry;
        company.allowance = _allowance;
        company.compensation = _compensation;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(AGENT_ROLE, _agent);
    }

    function getURI() public view returns (string memory) {
        return IPFS.getURI(company.cid);
    }

    function addAgent(address _newAgent) public onlyRole(AGENT_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAgent);
        _grantRole(AGENT_ROLE, _newAgent);
    }

    function removeAgent(address _agent) public onlyRole(AGENT_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, _agent);
        _revokeRole(AGENT_ROLE, _agent);
    }

    /////////////////////////// COMMON ///////////////////////////
    function setupAuxiliarContracts(
        address _cartesiAuction,
        address _cartesiInputBox,
        address _cartesiVerifier,
        address _cartesiERC20Portal,
        address _cartesiEtherPortal,
        address _priceFeed
    ) public onlyRole(AGENT_ROLE) {
        company.cartesiAuction = _cartesiAuction;
        company.cartesiInputBox = _cartesiInputBox;
        company.cartesiVerifier = _cartesiVerifier;
        company.cartesiERC20Portal = _cartesiERC20Portal;
        company.cartesiEtherPortal = _cartesiEtherPortal;
        company.parityRouter = _priceFeed;
        _grantRole(VERIFIER_ROLE, _cartesiVerifier);
        _grantRole(AUCTION_ROLE, _cartesiAuction);
    }

    /////////////////////////// VERIFIER ///////////////////////////
    function increaseAllowance(
        uint256 _amount
    ) external onlyRole(VERIFIER_ROLE) {
        company.allowance += _amount;
    }

    function decreaseAllowance(uint256 _amount) private {
        company.allowance -= _amount;
    }

    function addHardwareDevice(
        address _hardwareAddress
    ) public onlyRole(AGENT_ROLE) {
        company.hardwareDevices[address(this)].push(_hardwareAddress); //this function can be replaced by descentralized sqlite (input + inspect state)
        _grantRole(DEFAULT_ADMIN_ROLE, _hardwareAddress);
        _grantRole(HARDWARE_ROLE, _hardwareAddress);
    }

    function verifyRealWorldState(
        bytes calldata _RealWorldData
    ) public onlyRole(HARDWARE_ROLE) {
        IInputBox(company.cartesiInputBox).addInput(
            company.cartesiVerifier,
            _RealWorldData
        );
        //this logic below can be replaced by descentralized sqlite (input + inspect state)
        HardwareData.Hardware memory log = HardwareData.Hardware({
            hardwareAddress: msg.sender,
            lastVerification: block.timestamp
        });
        company.verificationHistory[address(this)].push(log);
    }

    function executeVerifierVoucher(
        bytes memory _payload,
        Proof calldata _proof
    ) public {
        ICartesiDApp(company.cartesiVerifier).executeVoucher(
            company.cartesiVerifier,
            _payload,
            _proof
        );
        emit VerifierVoucherExecuted(msg.sender, _payload, _proof);
    }

    /////////////////////////// BANK ///////////////////////////
    function mint(uint256 _amount) public onlyRole(AGENT_ROLE) {
        if (company.allowance < _amount) {
            revert DontHaveSuficientAllowance(_amount);
        } else {
            ICarbonCredit(company.token).mint(msg.sender, _amount);
            decreaseAllowance(_amount);
            emit Mint(msg.sender, _amount);
        }
    }

    function retire(uint256 _amount) public {
        IERC20(company.token).approve(address(this), _amount);
        ICarbonCredit(company.token).burn;
        emit Retire(msg.sender, _amount);
    }

    function quoteParity() public view returns (int256) {
        (, int price, , , ) = AggregatorV3Interface(company.parityRouter)
            .latestRoundData();
        return price / 1e8;
    }

    /////////////////////////// AUCTION ///////////////////////////
    function setAuctionDuration(uint256 _duration) private {
        company.auctionDuration = _duration * 1 hours;
    }

    function newAuction(
        uint256 _amount,
        uint256 _duration,
        uint256 _reservePricePerToken
    ) public onlyRole(AGENT_ROLE) {
        if (auctionState == AuctionState.ACTIVE) {
            revert AuctionHappening();
        } else {
            ICarbonCredit(company.token).approve(
                company.cartesiERC20Portal,
                _amount
            );
            setAuctionDuration(_duration);
            bytes memory _newAuctionHash = abi.encodePacked(
                company.auctionDuration,
                _reservePricePerToken
            );
            IERC20Portal(company.cartesiERC20Portal).depositERC20Tokens(
                IERC20(company.token),
                company.cartesiAuction,
                _amount,
                _newAuctionHash
            );
            auctionState = AuctionState.ACTIVE;
            emit NewAuction(
                msg.sender,
                _amount,
                _duration,
                _reservePricePerToken
            );
        }
    }

    function newBid(uint8 _amountPercentage) public payable {
        if (_amountPercentage < 0 && _amountPercentage >= 100) {
            revert InvalidAmountPercentage(_amountPercentage);
        } else if (auctionState != AuctionState.ACTIVE) {
            revert AuctionNotHappening();
        } else {
            bytes memory _executeLayerData = abi.encodePacked(
                _amountPercentage
            );
            IEtherPortal(company.cartesiEtherPortal).depositEther(
                company.cartesiAuction,
                _executeLayerData
            );
            emit NewBid(msg.sender, msg.value, _amountPercentage);
        }
    }

    function finalizeAuction() public onlyRole(AGENT_ROLE) {
        if (block.timestamp < company.auctionDuration) {
            revert AuctionNotHappening();
        } else {
            bytes memory _finalizeAuctionHash = abi.encodePacked(
                "Finish Auction"
            );
            IInputBox(company.cartesiAuction).addInput(
                company.cartesiAuction,
                _finalizeAuctionHash
            );
            delete auctionState;
            emit FinishedAuction(msg.sender);
        }
    }

    function executeAuctionVoucher(
        bytes calldata _payload,
        Proof calldata _proof
    ) public {
        ICartesiDApp(company.cartesiAuction).executeVoucher(
            company.cartesiAuction,
            _payload,
            _proof
        );
        emit AuctionVoucherExecuted(msg.sender, _payload, _proof);
    }

    function withdraw() external onlyRole(AGENT_ROLE) {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (success == false) {
            revert WithdrawFailed(msg.sender, address(this).balance);
        }
    }
}
