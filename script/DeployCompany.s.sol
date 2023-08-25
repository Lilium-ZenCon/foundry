// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Company} from "@contracts/entities/Company.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.sol";
import {SetupCompany} from "@utils/setup/SetupCompany.sol";

contract DeployCompany is Script, SetupLilium, SetupCompany {
    function run() external {
        SetupLilium setupLilium = new SetupLilium();
        SetupCompany setupCompany = new SetupCompany();

        (
            string memory _companyCid,
            string memory _companyName,
            string memory _companyCountry,
            string memory _companyIndustry,
            uint256 _companyAllowance,
            uint256 _companyCompensation,
            // address _companyAgent // set wallet before deploy

        ) = setupCompany.newCompanyArgs();

        (
            ,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            ,

        ) = setupLilium.liliumArgs();

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
