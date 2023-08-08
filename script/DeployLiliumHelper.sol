// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract DeployLiliumHelper {
    struct NetworkArgs {
        string cid;
        string name;
        address _InputBox;
        address _EtherPortal;
        address _ERC20Portal;
        address _PriceFeed;
        address agent;
    }

    function getSepoliaArgs() public pure returns(NetworkArgs memory){
        return NetworkArgs({
            cid: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            name: "Lilium",
            _InputBox: 0x5a723220579C0DCb8C9253E6b4c62e572E379945,
            _ERC20Portal: 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40,
            _EtherPortal: 0xA89A3216F46F66486C9B794C1e28d3c44D59591e,
            _PriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            agent: 0xFb05c72178c0b88BFB8C5cFb8301e542A21aF1b7
        });
    }
}