// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {CarbonCreditData} from "@libraries/storage/CarbonCreditData.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/interfaces/AggregatorV3Interface.sol";

contract CarbonCredit is AccessControl, ERC20 {
    CarbonCreditData.CarbonCredit public token;

    bytes32 constant MINTER_ROLE = keccak256("MINTER_ROLE");

    error InsufficientAmount(uint256 _amount);

    event Retire(address _sender, uint256 _amount);

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _decimals,
        address _certifier,
        address _priceFeed,
        address _cartesiInputBox
    ) ERC20(_tokenName, _tokenSymbol) {
        token.decimals = _decimals;
        token.admin = _certifier;
        token.parityRouter = _priceFeed;
        token.cartesiInputBox = _cartesiInputBox;
        _grantRole(DEFAULT_ADMIN_ROLE, _certifier);
    }

    function setCartesi(
        address _cartesiCertifier
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        token.cartesiCertifier = _cartesiCertifier;
    }

    function quoteParity() public view returns (int256) {
        (, int price, , , ) = AggregatorV3Interface(token.parityRouter)
            .latestRoundData();
        return price / 1e8;
    }

    function decimals() public pure override returns (uint8) {
        return 2;
    }

    function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
        _mint(_to, _amount);
    }

    function retire(uint256 _amount) external {
        if (balanceOf(_msgSender()) < _amount) {
            revert InsufficientAmount(_amount);
        } else {
            _burn(_msgSender(), _amount);
            emit Retire(_msgSender(), _amount);
        }
    }

    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        if (balanceOf(_msgSender()) < amount) {
            revert InsufficientAmount(amount);
        } else {
            _transfer(_msgSender(), to, amount);
            bytes memory _payload = abi.encodePacked(msg.sender, to, amount);
            IInputBox(token.cartesiInputBox).addInput(
                token.cartesiInputBox,
                _payload
            );
            return true;
        }
    }
}
