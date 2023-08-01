// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library HardwareData {
    struct Hardware {
        address hardwareAddress;
        uint256 lastVerification;
    }
}