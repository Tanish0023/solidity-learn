// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Sum{
    int value=0;
    uint nextValue;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(owner == msg.sender, "Owner funciton");
        _;
    }

    function add(int _addValue) public onlyOwner {
        value += _addValue;
    }

    function subtract(int _subValue) public onlyOwner  {
        value -= _subValue;
    }

    function getValue() public view returns (int) {
        return value;
    }
}