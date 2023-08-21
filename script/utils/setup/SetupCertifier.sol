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
        pure
        returns (CertifierArgs memory certifierArgs)
    {
        certifierArgs = CertifierArgs({
            cid: "QmRSAi9LVTuzN3zLu3kKeiESDug27gE3F6CFYvuMLFrt2C",
            name: "Verra",
            agent: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8, // set wallet before deploy
            tokenName: "VERRA",
            tokenSymbol: "VRR",
            tokenDecimals: 18
        });
    }
}
