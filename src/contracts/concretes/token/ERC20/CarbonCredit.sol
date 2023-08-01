// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {InputBox} from "@cartesi/contracts/inputs/InputBox.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OffsetCarbonToken is ERC20, AccessControl {

    address carbonTraceOwner; // variable to store contract owner
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE"); // variable to store minter role
    mapping(address => bool) private checkRegisterContractAddress;

    constructor(address _carbonTraceOwner) ERC20("OffsetCarbonToken", "OCT") { //adicionar os outros address depois
        carbonTraceOwner = _carbonTraceOwner;
    }

    // modifier to restrict access to the owner
    modifier onlyCarbonTraceOwner() {
        msg.sender == carbonTraceOwner;
        _;
    }

    // Auxiliar function to set register contract address on auth mapping
    function setRegisterContractAddress(address _newContract) external {
        checkRegisterContractAddress[_newContract] = true;
    }

    // function to update contract controller
    function updateController(
        address _newController
    ) public onlyCarbonTraceOwner {
        _grantRole(DEFAULT_ADMIN_ROLE, _newController);
    }

    // function to set minter contract
    function setMinter(address _newMinter) external {
        require(
            checkRegisterContractAddress[msg.sender] == true,
            "Permission denied"
        );
        _grantRole(MINTER_ROLE, _newMinter);
    }

    function grantMinterRole(address _grantAddress) public onlyRole(DEFAULT_ADMIN_ROLE){
        _grantRole(MINTER_ROLE, _grantAddress);
    }

    function revokeMinterRole(address _revokeAddress) public onlyRole(DEFAULT_ADMIN_ROLE){
        _revokeRole(MINTER_ROLE, _revokeAddress);
    }

    // function to mint tokens if the user has a role
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // function to retire OffSetCarbonTokens and store this transaction information
    function retire(uint256 amount) public virtual {
        require(
            amount >= 0,
            "The wallet does not have enough funds for this operation"
        );
        _burn(_msgSender(), amount);
    }

    // function to override token decimals
    function decimals() public pure override returns (uint8) {
        return 2;
    }
}