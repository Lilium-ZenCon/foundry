// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DeployerAccountArgs} from "@utils/storage/NewDeployerAccountArgs.sol";

contract SetupDeployerAccount is Script{
    DeployerAccountArgs public deployerAccountArgs;

    mapping(uint256 => DeployerAccountArgs) public deployerAccountByChainId;

    constructor() {
        deployerAccountByChainId[80001] = getMumbaiDeployerAccount();
        deployerAccountByChainId[31337] = getHardhatDeployerAccount();
        deployerAccountByChainId[11155111] = getSepoliaDeployerAccount();
        deployerAccountByChainId[383414847825] = getZeniqDeployerAccount();
        deployerAccountArgs = deployerAccountByChainId[block.chainid];
    }

    function getSepoliaDeployerAccount()
        internal
        view
        returns (DeployerAccountArgs memory sepoliaDeployerAccount)
    {
        sepoliaDeployerAccount = DeployerAccountArgs({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM")
        });
    }

    function getMumbaiDeployerAccount() internal view returns(DeployerAccountArgs memory mumbaiDeployerAccount) {
        mumbaiDeployerAccount = DeployerAccountArgs({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM")
        });
    }

    function getZeniqDeployerAccount() internal view returns(DeployerAccountArgs memory zeniqDeployerAccount) {
        zeniqDeployerAccount = DeployerAccountArgs({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM")
        });
    }

    function getHardhatDeployerAccount() internal view returns(DeployerAccountArgs memory hardhatDeployerAccount) {
        hardhatDeployerAccount = DeployerAccountArgs({
            deployer: vm.envUint("PRIVATE_KEY_LILIUM_HARDHAT")
        });
    }
}
