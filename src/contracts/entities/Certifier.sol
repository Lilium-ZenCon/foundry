// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ILilium} from "@interfaces/ILilium.sol";
import {IPFS} from "@libraries/function/IPFS.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {Company} from "@contracts/entities/Company.sol";
import {CertifierData} from "@libraries/storage/CertifierData.sol";

contract Certifier {
    CertifierData.Certifier public certifier;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 public constant MASTER_ROLE = keccak256("MASTER_ROLE");

    error Unouthorized();

    event NewCompany(address _company);

    constructor(
        string memory _cid,
        string memory _name,
        address _lilium,
        address _agent,
        address _masterAgent,
        address _cartesiInputBox,
        address _cartesiEtherPortal,
        address _cartesiERC20Portal
    ) {
        certifier.cid = _cid;
        certifier.name = _name;
        certifier.lilium = _lilium;
        certifier.agent = _agent;
        certifier.masterAgent = _masterAgent;
        certifier.cartesiInputBox = _cartesiInputBox;
        certifier.cartesiERC20Portal = _cartesiERC20Portal;
        certifier.cartesiEtherPortal = _cartesiEtherPortal;
    }

    modifier onlyAgent() {
        if (msg.sender != certifier.agent) {
            revert Unouthorized();
        }
        _;
    }

    modifier onlyMasterAgent() {
        if (msg.sender != certifier.masterAgent) {
            revert Unouthorized();
        }
        _;
    }

    function setCartesi(address _cartesiCertifier) public onlyMasterAgent {
        certifier.cartesiCertifier = _cartesiCertifier;
        ICarbonCredit(ILilium(certifier.lilium).getToken(address(this)))
            .setCartesi(_cartesiCertifier);
    }

    function getURI() public view returns (string memory) {
        return IPFS.getURI(certifier.cid);
    }

    function newCompany(
        string memory _cid,
        string memory _name,
        string memory _country,
        string memory _industry,
        uint256 _allowance,
        uint256 _compensation,
        address _agent
    ) public onlyAgent {
        Company company = new Company(
            _cid,
            _name,
            ILilium(certifier.lilium).getToken(address(this)),
            _country,
            _industry,
            _allowance,
            certifier.cartesiInputBox,
            certifier.cartesiERC20Portal,
            certifier.cartesiEtherPortal,
            _compensation,
            _agent
        );
        ICarbonCredit(ILilium(certifier.lilium).getToken(address(this)))
            .grantRole(MINTER_ROLE, address(company));
        emit NewCompany(address(company));
    }
}