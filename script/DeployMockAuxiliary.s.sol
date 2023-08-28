// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockCartesiDApp} from "@mocks/MockCartesiDApp.sol";
import {SetupCartesiDApp} from "@utils/setup/SetupCartesiDapp.sol";
import {SetupDeployerAccount} from "@utils/setup/SetupDeployerAccount.s.sol";
import {IConsensus} from "@cartesi/contracts/consensus/IConsensus.sol";

contract DeployLilium is Script {
    function run() external returns (address, address) {
        SetupCartesiDApp setupCartesiDApp = new SetupCartesiDApp();
        SetupDeployerAccount deployerAccount = new SetupDeployerAccount();

        uint256 _deployer = deployerAccount.deployerAccountArgs();

        (
            IConsensus _consensus,
            address _owner,
            bytes32 _templateHash
        ) = setupCartesiDApp.cartesiDAppArgs();

        vm.startBroadcast(_deployer);
        MockCartesiDApp verifier = new MockCartesiDApp(
            _consensus,
            _owner,
            _templateHash
        );
        MockCartesiDApp auction = new MockCartesiDApp(
            _consensus,
            _owner,
            _templateHash
        );
        vm.stopBroadcast();
        return (address(verifier), address(auction));
    }
}
