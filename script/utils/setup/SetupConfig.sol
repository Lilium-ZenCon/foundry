// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {LiliumArgs} from "@utils/storage/NewLiliumArgs.sol";
import {CompanyArgs} from "@utils/storage/NewCompanyArgs.sol";
import {CertifierArgs} from "@utils/storage/NewCertifierArgs.sol";

contract SetupConfig {
    CompanyArgs public newCompanyArgs;
    LiliumArgs public liliumArgs;
    CertifierArgs public newCertifierArgs;

    mapping(uint256 => LiliumArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[11155111] = getSepoliaLiliumArgs();
        chainIdToNetworkConfig[31337] = getMumbaiLiliumArgs();
        chainIdToNetworkConfig[80001] = getMumbaiLiliumArgs();
        liliumArgs = chainIdToNetworkConfig[block.chainid];
        getNewCertifierArgs();
        getNewCompanyArgs();
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
            agent: address(0) // set wallet before deploy
        });
    }

    function getMumbaiLiliumArgs()
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
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A, // ETH / USD
            agent: address(0) // set wallet before deploy
        });
    }

    function getAnvilLiliumArgs()
        internal
        view
        returns (LiliumArgs memory anvilNetworkConfig)
    {
        anvilNetworkConfig = LiliumArgs({
            cid: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            inputBox: address(0), // This is a mock
            etherPortal: address(0), // This is a mock
            erc20Portal: address(0), // This is a mock
            dappAddressRelay: address(0), // This is a mock
            priceFeed: address(0), // This is a mock
            agent: address(0) // set wallet before deploy
        });
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

    function getNewCompanyArgs()
        internal
        view
        returns (CompanyArgs memory companyArgs)
    {
        companyArgs = CompanyArgs({
            cid: "QmQp9iagQS9uEQPV7hg5YGwWmCXxAs2ApyBCkpcu9ZAK6k",
            name: "Gerdau",
            country: "Brazil",
            industry: "Steelworks",
            allowance: 1000000000000,
            compensation: 10000,
            agent: address(0) // set wallet before deploy
        });
    }
}
