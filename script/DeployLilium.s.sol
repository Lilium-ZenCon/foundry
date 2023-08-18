// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {HelperConfig} from "@script/HelperConfig.sol";

contract DeployLilium is Script, HelperConfig {

    function run() external {
        HelperConfig helperConfig = new HelperConfig();

        (string memory _cid, address _InputBox, address _EtherPortal, address _ERC20Portal, address _DAppAddressRelay, address _PriceFeed, address _agent) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        new Lilium(
            _cid,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _PriceFeed,
            _agent
        );
        vm.stopBroadcast();
    }
}
