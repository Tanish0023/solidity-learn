// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OrchaCoin is ERC20{
    address contractAddress;
    address owner;

    constructor(address _contractAddress) ERC20("OrchaCoin", "ORC"){
        owner = msg.sender;
        contractAddress = _contractAddress;
    }

    modifier isContract() {
        require(contractAddress == msg.sender);
        _;
    }

    modifier isOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function mint(address _account, uint256 _amount) public isContract{
        ERC20._mint(_account, _amount);
    }

    function UpdateContractAddress(address _newContractAddress) public isOwner{
        contractAddress = _newContractAddress;
    }


}