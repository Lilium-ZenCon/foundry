// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Company} from "@contracts/entities/Company.sol";

contract DeployLilium is Script {
    
    string _cid = "QmSLLtCVs2LxK5UySSRb5Rb5LGbVcCBooU6yypYXuR9xBW";
    string _name = "Vera";
    address _InputBox = 0x5a723220579C0DCb8C9253E6b4c62e572E379945;
    address _EtherPortal = 0xA89A3216F46F66486C9B794C1e28d3c44D59591e;
    address _ERC20Portal = 0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40;
    address _PriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address _agent = 0xFb05c72178c0b88BFB8C5cFb8301e542A21aF1b7;

    function run() external {
        vm.startBroadcast();
        new Lilium(
            _cid,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _PriceFeed,
            _agent
        );
        vm.stopBroadcast();
    }
}
