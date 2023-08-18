// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CertifierArgs} from "@utils/storage/NewCertifierArgs.sol";

contract SetupCertifier {
    CertifierArgs public newCertifierArgs;

    constructor() {
        getNewCertifierArgs();
    }

    function getNewCertifierArgs()
        internal
        view
        returns (CertifierArgs memory certifierArgs)
    {
        certifierArgs = CertifierArgs({
            cid: "QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C",
            name: "Verra",
            agent: address(0), // set wallet before deploy
            tokenName: "VERRA",
            tokenSymbol: "VRR",
            tokenDecimals: 18
        });
    }
}
