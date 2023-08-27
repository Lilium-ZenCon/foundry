// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title Company
 * @dev Company struct store Company data
 */
struct CompanyData {
    string cid;
    string name;
    address token;
    string country;
    string industry;
    uint256 allowance;
    uint256 auctionDuration;
    address cartesiAuction;
    address cartesiInputBox;
    address cartesiVerifier;
    address cartesiERC20Portal;
    address cartesiEtherPortal;
    address cartesiDAppAddressRelay;
    uint256 compensation;
    mapping (address => uint256) ledger;   
}