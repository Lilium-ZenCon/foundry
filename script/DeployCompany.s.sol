// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Company} from "@contracts/entities/Company.sol";
import {SetupConfig} from "@utils/setup/SetupConfig.sol";

contract DeployCompany is Script, SetupConfig {
    function run() external {
        SetupConfig helperConfig = new SetupConfig();

        (
            string memory _companyCid,
            string memory _companyName,
            string memory _companyCountry,
            string memory _companyIndustry,
            uint256 _companyAllowance,
            uint256 _companyCompensation,

        ) = helperConfig.newCompanyArgs();

        (
            ,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            ,

        ) = helperConfig.liliumArgs();

        vm.startBroadcast();
        new Company(
            _companyCid,
            _companyName,
            address(0), // Mocked token
            _companyCountry,
            _companyIndustry,
            _companyAllowance,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _companyCompensation,
            msg.sender
        );
        vm.stopBroadcast();
    }
}
