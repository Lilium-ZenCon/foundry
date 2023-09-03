// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {MockCartesiDApp} from "@mocks/MockCartesiDApp.sol";
import {SetupCartesiDApp} from "@utils/setup/SetupCartesiDapp.sol";
import {SetupDeployerAccount} from "@utils/setup/SetupDeployerAccount.s.sol";
import {IConsensus} from "@cartesi/contracts/consensus/IConsensus.sol";

contract DeployAuxiliary {
    function deploy() external returns (address, address) {
        SetupCartesiDApp setupCartesiDApp = new SetupCartesiDApp();
        (
            IConsensus _consensus,
            address _owner,
            bytes32 _templateHash
        ) = setupCartesiDApp.cartesiDAppArgs();

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
        return (address(verifier), address(auction));
    }
}
