// SPDX-License-Identifier: MIT

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
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";

contract Company is AccessControl {
    using IPFS for IPFS.Entity;

    IPFS.Entity public ipfs;
    AuctionState public auctionState;

    CompanyData.Company public company;
    HardwareData.Hardware public hardware;

    bytes32 constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 constant AUCTION_ROLE = keccak256("AUCTION_ROLE");
    bytes32 constant HARDWARE_ROLE = keccak256("HARDWARE_ROLE");
    bytes32 constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    error AuctionHappening();
    error AuctionNotHappening();
    error Unouthorized(address _sender);
    error DontHaveAllowance(uint256 _amount);
    error InsufficientAmount(uint256 _amount);
    error InvalidAmountPercentage(uint8 _amountPercentage);

    event FinishedAuction(msg.sender);
    event Mint(address _sender, uint256 _amount);
    event Retire(address _sender, uint256 _amount);
    event NewBid(msg.sender, msg.value, uint8 _amountPercentage);
    event VerifierVoucherExecuted(address _sender, bytes _payload, Proof _proof);
    event AuctionVoucherExecuted(address _sender, bytes _payload, Proof _proof);
    event NewAuction(msg.sender, uint256 _amount, uint256 _duration, uint256 _reservePricePerToken);

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
        company.auctionDuration = 0;
        company.cartesiAuction = address(0);
        company.cartesiInputBox = address(0);
        company.cartesiVerifier = address(0);
        company.cartesiERC20Portal = address(0);
        company.cartesiEtherPortal = address(0);
        company.parityRouter = address(0);
        company.agents[address(this)].push(_agent);
        company.hardwareDevices[address(this)].push(_hardwareAddress);
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    function setupAuxiliarContracts(
        address _cartesiAuction,
        address _cartesiInputBox,
        address _cartesiVerifier,
        address _cartesiERC20Portal,
        address _cartesiEtherPortal,
        address _priceFeed
    ) public onlyRole(AGENT_ROLE) {
        company.cartesiAuction = _cartesiAuction;
        company.cartesiInputBox = _cartesiAuction;
        company.cartesiVerifier = _cartesiVerifier;
        company.cartesiERC20Portal = _cartesiERC20Portal;
        company.cartesiEtherPortal = _cartesiEtherPortal;
        company.parityRouter = _priceFeed;
    }
    
    function addHardwareDevice(
        address _hardwareAddress
    ) public onlyRole(AGENT_ROLE) {
        company.hardwareDevices[address(this)].push(_hardwareAddress);//this function can be replaced by descentralized sqlite (input with inspect state)
        _grantRole(DEFAULT_ADMIN_ROLE, _hardwareAddress);
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

    function addAgent(address _newAgent) public onlyRole(AGENT_ROLE) {
        company.agents[address(this)].push(_agent); //this function can be replaced by descentralized sqlite (input with inspect state)
        _grantRole(DEFAULT_ADMIN_ROLE, _newAgent);
    }

    //this function can be replaced by descentralized sqlite (input with inspect state)
    function getagents() external view returns (address[] memory) {
        return company.agents[address(this)];
    }

    function getURI() external view returns (string memory) {
        return ipfs.getURI(company.cid);
    }

    function quoteParity() public view returns (int256) {
        (, int price, , , ) = AggregatorV3Interface(company.parityRouter)
            .latestRoundData();
        return price / 1e8;
    }

    function setAuctionDuration(uint256 _duration) private {
        company.auctionDuration = _duration * 1 hours;
    }

    function increaseAllowance(
        uint256 _amount
    ) external onlyRole(VERIFIER_ROLE) {
        company.allowance += _amount;
    }

    function decreaseAllowance(uint256 _amount) private {
        company.allowance -= _amount;
    }

    function verifyRealWorldState(
        bytes calldata _RealWorldData
    ) public onlyRole(HARDWARE_ROLE) {
        bytes calldata _payload = abi.encodePacked(_RealWorldData);
        IInputBox(company.cartesiInputBox).addInput(company.cartesiVerifier, _payload);
        //this function can be replaced by descentralized sqlite (input with inspect state)
        HardwareData.Hardware({
            hardwareAddress: msg.sender,
            lastVerification: block.timestamp
        });
    }

    function newAuction(
        uint256 _amount,
        uint256 _duration,
        uint256 _reservePricePerToken
    ) public onlyRole(AGENT_ROLE) {
        if (auctionState == AuctionState.ACTIVE) {
            revert AuctionHappening();
        } else {
            setAuctionDuration(_duration);
            ICarbonCredit(company.token).allowance(msg.sender, company.cartesiERC20Portal);
            ICarbonCredit(company.token).approve(company.cartesiERC20Portal, _amount);
            bytes calldata _newAuctionHash = abi.encode(
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
            emit NewAuction(msg.sender, _amount, _duration, _reservePricePerToken);
        }
    }

    function newBid(
        uint8 _amountPercentage
    ) public payable {
        if (_amountPercentage < 0 && _amountPercentage >= 100) {
            revert InvalidAmountPercentage(_amountPercentage);
        } else if (auctionState != AuctionState.ACTIVE) {
            revert AuctionNotHappening();
        } else {
            bytes calldata _executeLayerData = abi.encodePacked(_amountPercentage);
            IEtherPortal(company.cartesiEtherPortal).depositEther(
                company.cartesiAuction,
                _executeLayerData
            );
            emit NewBid(msg.sender, msg.value, _amountPercentage);
        }
    }

    function finalizeAuction() public onlyRole(AGENT_ROLE) {
        bytes calldata _finalizeAuctionHash = abi.encodePacked("Finish Auction");
        IInputBox(company.cartesiAuction).addInput(
            company.cartesiAuction,
            _finalizeAuctionHash
        );
        delete auctionState;
        emit FinishedAuction(msg.sender);
    }

    function executeVerifierVoucher(
        bytes calldata _payload,
        Proof memory _proof
    ) public {
        ICartesiDApp(company.cartesiVerifier).executeVoucher(
            company.cartesiVerifier,
            _payload,
            _proof
        );
        emit VerifierVoucherExecuted(msg.sender, _payload, _proof);
    }

    function executeAuctionVoucher(
        bytes calldata _payload,
        Proof memory _proof
    ) public {
        ICartesiDApp(company.cartesiAuction).executeVoucher(
            company.cartesiAuction,
            _payload,
            _proof
        );
        emit AuctionVoucherExecuted(msg.sender, _payload, _proof);
    }

    function mint(uint256 _amount) public onlyRole(AGENT_ROLE) {
        if (company.agents[msg.sender] != true) {
            revert Unouthorized(msg.sender);
        } else {
            ICarbonCredit(company.token).mint(msg.sender, _amount);
            decreaseAllowance(_amount);
            emit Mint(msg.sender, _amount);
        }
    }

    function retire(uint256 _amount) public {
        if (IERC20(company.token).balanceOf(msg.sender) < _amount) {
            revert InsufficientAmount(_amount);
        } else {
            ICarbonCredit(company.token).burn(msg.sender, _amount);
            emit Retire(msg.sender, _amount);
        }
    }
}
