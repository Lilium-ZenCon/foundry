// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CompanyArgs} from "@utils/storage/NewCompanyArgs.sol";

contract SetupCompany {
    CompanyArgs public newCompanyArgs;

    constructor() {
        getNewCompanyArgs();
    }

    function getNewCompanyArgs()
        internal
        view
        returns (CompanyArgs memory companyArgs)
    {
        companyArgs = CompanyArgs({
            cid: "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k",
            name: "Gerdau",
            country: "Brazil",
            industry: "Steelworks",
            allowance: 1000000000000,
            compensation: 10000,
            agent: msg.sender
        });
    }
}
