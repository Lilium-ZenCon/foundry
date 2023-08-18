// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {CarbonCredit} from "@contracts/token/ERC20/CarbonCredit.sol";
import {SetupCarbonCredit} from "@utils/setup/SetupCarbonCredit.sol";

contract DeployCertifier is Script, SetupCarbonCredit {
    function run() external {
        SetupCarbonCredit setupCarbonCredit = new SetupCarbonCredit();

        (
            string memory _tokenName,
            string memory _tokenSymbol,
            uint8 _decimals,
            address _certifier,
            address _priceFeed
        ) = setupCarbonCredit.newCarbonCreditArgs();

        vm.startBroadcast();
        new CarbonCredit(
            _tokenName,
            _tokenSymbol,
            _decimals, // Mocked lilium contract when deployed on Anvil
            _certifier,
            _priceFeed // Mocked contract when deployed on Anvil
        );
        vm.stopBroadcast();
    }
}
