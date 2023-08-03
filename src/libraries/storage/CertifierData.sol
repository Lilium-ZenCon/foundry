// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CompanyData} from "@libraries/storage/CompanyData.sol";

library CertifierData {
    struct Certifier {
        string cid;
        string name;
        address token;
    }
}