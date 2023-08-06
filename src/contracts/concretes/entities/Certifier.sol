// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ILilium} from "@interfaces/ILilium.sol";
import {IPFS} from "@libraries/function/IPFS.sol";
import {ICarbonCredit} from "@interfaces/ICarbonCredit.sol";
import {CompanyData} from "@libraries/storage/CompanyData.sol";
import {IInputBox} from "@cartesi/contracts/inputs/IInputBox.sol";
import {Company} from "@contracts/concretes/entities/Company.sol";
import {CertifierData} from "@libraries/storage/CertifierData.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Certifier is AccessControl {
    CertifierData.Certifier public certifier;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant AGENT_ROLE = keccak256("AGENT_ROLE");
    bytes32 public constant MASTER_ROLE = keccak256("MASTER_ROLE"); 

    error SetMinterFailed(address _company);

    event NewCompany(address _compan);

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
        certifier.cartesiInputBox = _cartesiInputBox;
        certifier.cartesiERC20Portal = _cartesiERC20Portal;
        certifier.cartesiEtherPortal = _cartesiEtherPortal;
        _grantRole(DEFAULT_ADMIN_ROLE, _masterAgent);
        _grantRole(MASTER_ROLE, _masterAgent);
        _grantRole(DEFAULT_ADMIN_ROLE, _agent);
        _grantRole(AGENT_ROLE, _agent);
    }

    function setCartesi(address _cartesiCertifier) public onlyRole(MASTER_ROLE) {
        certifier.cartesiCertifier = _cartesiCertifier;
        ICarbonCredit(ILilium(certifier.lilium).getToken(address(this))).setCartesi(_cartesiCertifier);
    }

    function getURI() public view returns (string memory) {
        return IPFS.getURI(certifier.cid);
    }

    function addAgent(address _newAagent) public onlyRole(AGENT_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newAagent);
        _grantRole(AGENT_ROLE, _newAagent);
    }

    function removeAgent(address _agent) public onlyRole(AGENT_ROLE) {
        _revokeRole(DEFAULT_ADMIN_ROLE, _agent);
        _revokeRole(AGENT_ROLE, _agent);
    }

    function newCompany(
        string memory _cid,
        string memory _name,
        string memory _country,
        string memory _industry,
        uint256 _allowance,
        uint256 _compensation,
        address _agent
    ) public onlyRole(AGENT_ROLE) {
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
        ICarbonCredit(ILilium(certifier.lilium).getToken(address(this))).grantRole(MINTER_ROLE, address(company));
        emit NewCompany(address(company));
    }
}