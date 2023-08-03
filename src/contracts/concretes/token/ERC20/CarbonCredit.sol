// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {TokenData} from "@libraries/storage/TokenData.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract CarbonCredit is AccessControl, ERC20 {
    TokenData.Token public token;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    error InsufficientAmount(uint256 _amount);

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _decimals,
        address _tokenAdmin
    ) ERC20(_tokenName, _tokenSymbol) {
        token.decimals = _decimals;
        token.admin = _tokenAdmin;
        _grantRole(DEFAULT_ADMIN_ROLE, _tokenAdmin);
        _grantRole(ADMIN_ROLE, _tokenAdmin);
    }

    function setCompany(address _company) external onlyRole(ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, _company);
    }

    function setAdmin(address _newAdmin) public onlyRole(ADMIN_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAdmin);
        _grantRole(ADMIN_ROLE, _newAdmin);
    }

    function removeAdmin(address _admin) public onlyRole(ADMIN_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, _admin);
        _revokeRole(ADMIN_ROLE, _admin);
    }

    function mint(address _to, uint256 _amount) public onlyRole(MINTER_ROLE) {
        _mint(_to, _amount);
    }

    function retire(uint256 _amount) external {
        if (balanceOf(_msgSender()) <= _amount) {
            revert InsufficientAmount(_amount);
        } else {
            _burn(_msgSender(), _amount);
        }
    }

    function decimals() public pure override returns (uint8) {
        return 2;
    }
}
