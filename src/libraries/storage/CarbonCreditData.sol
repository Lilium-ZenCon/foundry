// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract CarbonCreditData {
    struct CarbonCredit {
        uint256 totalSupply;
        uint256 decimals;
        address admin;
        address parityRouter;
        address cartesiCertifier;
        address cartesiInputBox;
    }
}