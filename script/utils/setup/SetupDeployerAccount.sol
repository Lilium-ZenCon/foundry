// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DeployerAccount} from "@utils/storage/NewDeployerAccountArgs.sol";

contract SetupDeployerAccount is Script{
    DeployerAccount public deployerAccount;

    mapping(uint256 => DeployerAccount) public deployerAccountByChainId;

    constructor() {
        deployerAccountByChainId[11155111] = getSepoliaDeployerAccount();
        deployerAccountByChainId[80001] = getMumbaiDeployerAccount();
        deployerAccountByChainId[31337] = getLocalhostDeployerAccount();
        deployerAccount = deployerAccountByChainId[block.chainid];
    }

    function getSepoliaDeployerAccount()
        internal
        view
        returns (DeployerAccount memory sepoliaDeployerAccount)
    {
        sepoliaDeployerAccount = DeployerAccount({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM")
        });
    }

    function getMumbaiDeployerAccount() internal view returns(DeployerAccount memory mumbaiDeployerAccount) {
        mumbaiDeployerAccount = DeployerAccount({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM")
        });
    }

    function getLocalhostDeployerAccount() internal view returns(DeployerAccount memory localhostDeployerAccount) {
        localhostDeployerAccount = DeployerAccount({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM_LOCALHOST")
        });
    }
}
