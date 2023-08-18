// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

struct CarbonCreditArgs {
    string tokenName;
    string tokenSymbol;
    uint8 decimals;
    address certifier;
    address priceFeed;
}