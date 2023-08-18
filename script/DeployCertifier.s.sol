// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Certifier} from "@contracts/entities/Certifier.sol";
import {SetupConfig} from "@utils/setup/SetupConfig.sol";

contract DeployCertifier is Script, SetupConfig {
    function run() external {
        SetupConfig helperConfig = new SetupConfig();

        (
            string memory _certifierCid,
            string memory _certifierName,
            ,
            ,
            ,

        ) = helperConfig.newCertifierArgs();

        (
            ,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            ,

        ) = helperConfig.liliumArgs();

        vm.startBroadcast();
        new Certifier(
            _certifierCid,
            _certifierName,
            address(0), // Mocked contract
            msg.sender,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay
        );
        vm.stopBroadcast();
    }
}
