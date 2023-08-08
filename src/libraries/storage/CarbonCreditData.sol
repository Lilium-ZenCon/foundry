// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

/**
 * @title CarbonCreditData
 * @dev CarbonCreditData library to store CarbonCredit data
 */
library CarbonCreditData {
    struct CarbonCredit {
        uint256 totalSupply;
        uint256 decimals;
        address admin;
        address parityRouter;
        address cartesiCertifier;
    }
}
