// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {CertifierData} from "@libraries/storage/CertifierData.sol";

/**
 * @title LiliumData
 * @dev LiliumData library to store Lilium data
 */
library LiliumData {
    struct Lilium {
        string cid;
        address cartesiInputBox;
        address cartesiERC20Portal;
        address cartesiEtherPortal;
        address cartesiDAppAddressRelay;
        address parityRouter;
        address agent;
    }
}
