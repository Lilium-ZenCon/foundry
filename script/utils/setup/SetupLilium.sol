// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {LiliumArgs} from "@utils/storage/NewLiliumArgs.sol";

contract SetupLilium {
    LiliumArgs public liliumArgs;

    mapping(uint256 => LiliumArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[11155111] = getSepoliaLiliumArgs();
        chainIdToNetworkConfig[31337] = getMumbaiLiliumArgs();
        chainIdToNetworkConfig[80001] = getMumbaiLiliumArgs();
        liliumArgs = chainIdToNetworkConfig[block.chainid];
    }

    function getSepoliaLiliumArgs()
        internal
        view
        returns (LiliumArgs memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = LiliumArgs({
            cid: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, // ETH / USD
            agent: msg.sender // set wallet before deploy
        });
    }

    function getMumbaiLiliumArgs()
        internal
        view
        returns (LiliumArgs memory mumbaiNetworkConfig)
    {
        mumbaiNetworkConfig = LiliumArgs({
            cid: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A, // ETH / USD
            agent: msg.sender // set wallet before deploy
        });
    }

    function getLocalhostLiliumArgs()
        internal
        view
        returns (LiliumArgs memory localhostNetworkConfig)
    {
        localhostNetworkConfig = LiliumArgs({
            cid: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: address(0), // ETH / USD mocked contract
            agent: msg.sender // set wallet before deploy
        });
    }
}
