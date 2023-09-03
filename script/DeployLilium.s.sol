// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DeployAuxiliary} from "@script/DeployMockAuxiliary.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.s.sol";
import {MockV3Aggregator} from "@mocks/MockV3Aggregator.sol";
import {SetupDeployerAccount} from "@utils/setup/SetupDeployerAccount.s.sol";

contract DeployLilium is Script, SetupLilium {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    function run() external {
        SetupLilium helperConfig = new SetupLilium();
        SetupDeployerAccount deployerAccount = new SetupDeployerAccount();
        DeployAuxiliary auxiliary = new DeployAuxiliary();
        uint256 _deployer = deployerAccount.deployerAccountArgs();

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
        if (block.chainid == 31337 || block.chainid == 383414847825) {
            _PriceFeed = address(new MockV3Aggregator(DECIMALS, INITIAL_PRICE));
            (address verifier, address auction) = auxiliary.deploy();
            console.log(address(verifier),address(auction));
        }
        Lilium lilium = new Lilium(
            _cid,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _PriceFeed,
            _agent
        );
        vm.stopBroadcast();
        console.log(address(lilium));
    }
}
