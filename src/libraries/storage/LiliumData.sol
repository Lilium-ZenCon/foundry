// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CertifierData} from "@libraries/storage/CertifierData.sol";

library LiliumData {
    struct Lilium {
        string cid;
        string name;
        address cartesiInputBox;
        address cartesiERC20Portal;
        address cartesiEtherPortal;
        address parityRouter;
    }
}