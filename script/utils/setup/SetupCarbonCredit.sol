// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@mocks/MockV3Aggregator.sol";
import {CarbonCreditArgs} from "@utils/storage/NewCarbonCreditArgs.sol";

contract SetupCarbonCredit is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    CarbonCreditArgs public newCarbonCreditArgs;

    constructor() {
        getNewCarbonCreditArgs();
    }

    function getNewCarbonCreditArgs()
        internal
        returns (CarbonCreditArgs memory carbonCreditArgs)
    {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY_LILIUM_HARDHAT"));
        MockV3Aggregator _mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        carbonCreditArgs = CarbonCreditArgs({
            tokenName: "VERRA",
            tokenSymbol: "VRR",
            decimals: 2,
            certifier: address(0),
            priceFeed: address(_mockPriceFeed) // Mocked address
        });
    }
}
