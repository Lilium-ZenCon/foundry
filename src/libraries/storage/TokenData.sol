// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract TokenData {
    struct Token {
        uint256 totalSupply;
        uint256 decimals;
        address admin;
    }
}