// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CarbonCreditArgs} from "@utils/storage/NewCarbonCreditArgs.sol";

contract SetupCarbonCredit {
    CarbonCreditArgs public newCarbonCreditArgs;

    constructor() {
        getNewCarbonCreditArgs();
    }

    function getNewCarbonCreditArgs()
        internal
        view
        returns (CarbonCreditArgs memory carbonCreditArgs)
    {
        carbonCreditArgs = CarbonCreditArgs({
            tokenName: "VERRA",
            tokenSymbol: "VRR",
            decimals: 2, // Mocked value
            certifier: address(0), // Mocked address
            priceFeed: address(0) // Mocked address
        });
    }
}
