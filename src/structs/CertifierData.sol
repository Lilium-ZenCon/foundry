// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title Certifier
 * @dev Certifier struct store Certifier data
 */
struct CertifierData {
    string cid;
    string name;
    address lilium;
    address agent;
    address token;
    address cartesiInputBox;
    address cartesiCertifier;
    address cartesiERC20Portal;
    address cartesiEtherPortal;
    address cartesiDAppAddressRelay;
}