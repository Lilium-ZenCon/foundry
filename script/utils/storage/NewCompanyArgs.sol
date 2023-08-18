// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

struct CompanyArgs {
    string cid;
    string name;
    string country;
    string industry;
    uint256 allowance;
    uint256 compensation;
    address agent;
}