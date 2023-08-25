// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DeployLilium} from "@script/DeployLilium.s.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.sol";
import {Certifier} from "@contracts/entities/Certifier.sol";
import {SetupCertifier} from "@utils/setup/SetupCertifier.sol";

contract DeployCertifier is Script, SetupCertifier, SetupLilium {
    function run() external {
        SetupLilium setupLilium = new SetupLilium();
        SetupCertifier setupCertifier = new SetupCertifier();

        (
            string memory _certifierCid,
            string memory _certifierName,
            ,
            ,
            ,

        ) = setupCertifier.newCertifierArgs();

        (
            ,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            address _PriceFeed,

        ) = setupLilium.liliumArgs();

        vm.startBroadcast();
        address _lilium = DeployLilium.run();
        new Certifier(
            _certifierCid,
            _certifierName,
            _lilium, // Mocked lilium contract when deployed on Anvil
            msg.sender,
            _InputBox, // Mocked contract when deployed on Anvil
            _EtherPortal, // Mocked contract when deployed on Anvil
            _ERC20Portal, // Mocked contract when deployed on Anvil
            _DAppAddressRelay // Mocked contract when deployed on Anvil
        );
        vm.stopBroadcast();
    }
}
