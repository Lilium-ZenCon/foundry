// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library IPFS {
    struct Entity {
        string cid;
    }

    function getway() internal pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getURI(
        Entity storage entity
    ) internal view returns (string memory) {
        return string(abi.encodePacked(getway(), entity.cid));
    }
}
