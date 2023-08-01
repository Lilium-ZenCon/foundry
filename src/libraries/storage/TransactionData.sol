// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library TransactionData {
    struct Transaction {
        address buyer;
        uint256 amount;
        bytes4 identifier;
        uint256 timestamp;
        address company;
    }
}