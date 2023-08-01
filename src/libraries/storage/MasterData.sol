// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CertifierData} from "@libraries/storage/CertifierData.sol";

library LiliumStructure {
    struct Lilium {
        string cid;
        string name;
        mapping(address => bool) agents;
        mapping(address => CertifierData.Certifier[]) clients;
    }
}