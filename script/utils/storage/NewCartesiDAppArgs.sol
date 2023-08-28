// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IConsensus} from "@cartesi/contracts/consensus/IConsensus.sol";

struct CartesiDAppArgs {
    IConsensus consensus;
    address owner;
    bytes32 templateHash;
}