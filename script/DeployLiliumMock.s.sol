// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {DeployAuxiliary} from "@script/DeployMockAuxiliary.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.s.sol";
import {MockV3Aggregator} from "@mocks/MockV3Aggregator.sol";
import {SetupDeployerAccount} from "@utils/setup/SetupDeployerAccount.s.sol";

contract DeployLilium is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    SetupLilium helperConfig = new SetupLilium();
    SetupDeployerAccount deployerAccount = new SetupDeployerAccount();
    uint256 _deployer = deployerAccount.deployerAccountArgs();

    function run() external {
        {
            vm.startBroadcast(_deployer);
            (
                string memory _cid,
                address _InputBox,
                address _EtherPortal,
                address _ERC20Portal,
                address _DAppAddressRelay,
                ,
                address _agent
            ) = helperConfig.liliumArgs();
            DeployAuxiliary auxiliary = new DeployAuxiliary();
            address _MockPriceFeed = address(
                new MockV3Aggregator(DECIMALS, INITIAL_PRICE)
            );
            (address verifier, address auction) = auxiliary.deploy();
            console.log(address(verifier), address(auction));

            Lilium custom_lilium = new Lilium(
                _cid,
                _InputBox,
                _EtherPortal,
                _ERC20Portal,
                _DAppAddressRelay,
                _MockPriceFeed,
                _agent
            );

            console.log(address(custom_lilium));
            vm.stopBroadcast();
        }
    }
}
