// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {CartesiDAppArgs} from "@utils/storage/NewCartesiDAppArgs.sol";
import {IConsensus} from "@cartesi/contracts/consensus/IConsensus.sol";

contract SetupCartesiDApp is Script {
    CartesiDAppArgs public cartesiDAppArgs;

    bytes32 public constant CARTESI_DAPP_TEMPLATE_HASH =
        keccak256("CartesiDAppTemplate");

    mapping(uint256 => CartesiDAppArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[31337] = getHardhatLiliumArgs();
        cartesiDAppArgs = chainIdToNetworkConfig[block.chainid];
    }

    function getHardhatLiliumArgs()
        internal
        pure
        returns (CartesiDAppArgs memory hardhatNetworkConfig)
    {
        hardhatNetworkConfig = CartesiDAppArgs({
            consensus: IConsensus(0x1B282530a52F67ce4613Fe52D90273f960910afc),
            owner: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            templateHash: CARTESI_DAPP_TEMPLATE_HASH
        });
    }
}
