// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {TransactionData} from "@libraries/storage/TransactionData.sol";
import {HardwareData} from "@libraries/storage/HardwareData.sol";

library CompanyData {
    struct Company {
        string cid;
        string name;
        address token;
        string country;
        string industry;
        uint256 allowance;
        uint256 compensation;
        address cartesiAuction;
        address cartesiInputBox;
        address cartesiVerifier;
        address cartesiERC20Portal;
        address cartesiEtherPortal;
        address parityRouter;
        mapping(address => address[]) agents; // this can be replaced by descentralized sqlite (input with inspect state)
        mapping(address => address[]) hardwareDevices; // this can be replaced by descentralized sqlite (input with inspect state)
        mapping(address => HardwareData.Hardware[]) verificationHistory; // this can be replaced by descentralized sqlite (input with inspect state)
        mapping(address => TransactionData.Transaction[]) transactionHistory; // this can be replaced by descentralized sqlite (input with inspect state)
    }
}