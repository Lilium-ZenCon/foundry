// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract HelperConfig {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        string cid;
        address inputBox;
        address etherPortal;
        address erc20Portal;
        address dappAddressRelay;
        address priceFeed;
        address agent;
    }

    mapping(uint256 => NetworkConfig) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[11155111] = getSepoliaEthConfig();
        chainIdToNetworkConfig[31337] = getAnvilEthConfig();
        chainIdToNetworkConfig[80001] = getMumbaiEthConfig();
        activeNetworkConfig = chainIdToNetworkConfig[block.chainid];
    }

    function getSepoliaEthConfig()
        internal
        view
        returns (NetworkConfig memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = NetworkConfig({
            cid: "QmSLLtCVs2LxK5UySSRb5Rb5LGbVcCBooU6yypYXuR9xBW",
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, // ETH / USD
            agent: msg.sender
        });
    }

    function getMumbaiEthConfig() internal view returns (NetworkConfig memory sepoliaNetworkConfig) {
        sepoliaNetworkConfig = NetworkConfig({
            cid: "QmSLLtCVs2LxK5UySSRb5Rb5LGbVcCBooU6yypYXuR9xBW",
            inputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            etherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            erc20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            dappAddressRelay: 0x8Bbc0e6daB541DF0A9f0bDdA5D41B3B08B081d55,
            priceFeed: 0x0715A7794a1dc8e42615F059dD6e406A6594651A, // ETH / USD
            agent: msg.sender
        });
    }

    function getAnvilEthConfig()
        internal
        view
        returns (NetworkConfig memory anvilNetworkConfig)
    {
        anvilNetworkConfig = NetworkConfig({
            cid: "QmSLLtCVs2LxK5UySSRb5Rb5LGbVcCBooU6yypYXuR9xBW",
            inputBox: address(0), // This is a mock
            etherPortal: address(0), // This is a mock
            erc20Portal: address(0), // This is a mock
            dappAddressRelay: address(0), // This is a mock
            priceFeed: address(0), // This is a mock
            agent: msg.sender
        });
    }
}
