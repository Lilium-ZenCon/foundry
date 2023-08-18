// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Lilium} from "@contracts/entities/Lilium.sol";
import {SetupLilium} from "@utils/setup/SetupLilium.sol";
import {SetupCompany} from "@utils/setup/SetupCompany.sol";
import {SetupCertifier} from "@utils/setup/SetupCertifier.sol";

struct System {
    address lilium;
    address certifier;
    address token;
    address company;
}

contract DeploySystem is Script, SetupCertifier, SetupLilium, SetupCompany {
    System public system;

    function run() external {
        SetupLilium setupLilium = new SetupLilium();
        SetupCompany setupCompany = new SetupCompany();
        SetupCertifier setupCertifier = new SetupCertifier();

        (
            string memory _liliumCid,
            address _InputBox,
            address _EtherPortal,
            address _ERC20Portal,
            address _DAppAddressRelay,
            address _PriceFeed,
            address _liliumAgent // set before deploy
        ) = setupLilium.liliumArgs();

        (
            string memory _certifierCid,
            string memory _certifierName,
            address _certifierAgent, // set before deploy
            string memory _certifierTokenName,
            string memory _certifierTokenSymbol,
            uint8 _tokenDecimals
        ) = setupCertifier.newCertifierArgs();

        (
            string memory _companyCid,
            string memory _companyName,
            string memory _companyCountry,
            string memory _companyIndustry,
            uint256 _companyAllowance,
            uint256 _companyCompensation,
            address _companyAgent
        ) = setupCompany.newCompanyArgs();

        vm.startBroadcast();
        Lilium lilium = new Lilium(
            _liliumCid,
            _InputBox,
            _EtherPortal,
            _ERC20Portal,
            _DAppAddressRelay,
            _PriceFeed,
            msg.sender
        );

        (bool liliumSuccess, bytes memory liliumData) = address(lilium).call(
            abi.encodeWithSignature(
                "newCertifier(string,string,address,string,string,uint8)",
                _certifierCid,
                _certifierName,
                msg.sender,
                _certifierTokenName,
                _certifierTokenSymbol,
                _tokenDecimals
            )
        );

        if (!liliumSuccess) {
            revert(string(liliumData));
        } else {
            (address certifier, address token) = abi.decode(
                liliumData,
                (address, address)
            );
            system.lilium = address(lilium);
            system.certifier = certifier;
            system.token = token;

            (bool certifierSuccess, bytes memory certifierData) = address(
                certifier
            ).call(
                    abi.encodeWithSignature(
                        "newCompany(string,string,string,string,uint256,uint256,address)",
                        _companyCid,
                        _companyName,
                        _companyCountry,
                        _companyIndustry,
                        _companyAllowance,
                        _companyCompensation,
                        _companyAgent
                    )
                );

            if (!certifierSuccess) {
                revert(string(certifierData));
            } else {
                address company = abi.decode(certifierData, (address));
                system.company = company;
            }
        }
        console.log(
            system.lilium,
            system.certifier,
            system.token,
            system.company
        );
        vm.stopBroadcast();
    }
}