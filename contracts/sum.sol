// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Sum{
    uint value;
    uint nextValue;

    constructor(uint _initialValue){
        value = _initialValue;
    }

    function add(uint _addValue) public  {
        value += _addValue;
    }

    function getValue() public view returns (uint) {
        return value;
    }
}