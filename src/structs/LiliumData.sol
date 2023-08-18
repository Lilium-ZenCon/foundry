// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title Lilium
 * @dev Lilium struct store Lilium data
 */
struct LiliumData {
    string cid;
    address cartesiInputBox;
    address cartesiERC20Portal;
    address cartesiEtherPortal;
    address cartesiDAppAddressRelay;
    address parityRouter;
    address agent;
}
