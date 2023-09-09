// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.s.sol";
import {SetupDeployerAccount} from "@utils/setup/SetupDeployerAccount.s.sol";

contract DeployLilium is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    SetupLilium helperConfig = new SetupLilium();
    SetupDeployerAccount deployerAccount = new SetupDeployerAccount();
    uint256 _deployer = deployerAccount.deployerAccountArgs();

    function run() external {
        (
            string memory _cid,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            address _PriceFeed,
            address _agent
        ) = helperConfig.liliumArgs();
        vm.startBroadcast(_deployer);
        Lilium lilium = new Lilium(
            _cid,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _PriceFeed,
            _agent
        );
        console.log(address(lilium));
        vm.stopBroadcast();
    }
}
