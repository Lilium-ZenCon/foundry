// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CompanyData} from "@libraries/storage/CompanyData.sol";

library CertifierData {
    struct Certifier {
        string cid;
        string name;
        address lilium;
        address agent;
        address masterAgent;
        address cartesiInputBox;
        address cartesiCertifier;
        address cartesiERC20Portal;
        address cartesiEtherPortal;
    }
}