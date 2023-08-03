// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

library IPFS {
    function getway() internal pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getURI(string memory _cid) internal pure returns (string memory) {
        return string(abi.encodePacked(getway(), _cid));
    }
}
