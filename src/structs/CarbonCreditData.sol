// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

/**
 * @title CarbonCredit
 * @dev CarbonCredit struct store CarbonCredit data
 */
struct CarbonCreditData {
    uint256 totalSupply;
    uint256 decimals;
    address admin;
    address parityRouter;
    address cartesiCertifier;
}