// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {TransactionData} from "@libraries/storage/TransactionData.sol";

library CertifierData {
    struct Certifier {
        string cid;
        string name;
        mapping(address => bool) agents;
        mapping(address => CompanyData.Company[]) clients;
        mapping(address => TransactionData.Transaction[]) history;
    }
}