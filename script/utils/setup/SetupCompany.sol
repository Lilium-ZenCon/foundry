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
        pure
        returns (CompanyArgs memory companyArgs)
    {
        companyArgs = CompanyArgs({
            cid: "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k",
            name: "Gerdau",
            country: "Brazil",
            industry: "Steelworks",
            allowance: 1000000000000,
            compensation: 10000,
            agent: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC // set wallet before deploy
        });
    }
}
