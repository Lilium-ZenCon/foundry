// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title CompanyData
 * @dev CompanyData library to store Company data
 */
library CompanyData {
    struct Company {
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
    }
}
