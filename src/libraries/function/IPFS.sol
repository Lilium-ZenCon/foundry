// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title IPFS
 * @dev Auxiliary library to interact with IPFS
 */
library IPFS {
    /**
     * @dev Returns the IPFS gateway
     */
    function getway() internal pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    /**
     * @notice Return the IPFS URI
     * @dev Concate the IPFS gateway with the CID
     */
    function getURI(string memory _cid) internal pure returns (string memory) {
        return string.concat(getway(), _cid);
    }
}
