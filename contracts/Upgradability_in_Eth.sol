// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Storage{
    uint public num;
    address implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function setNum(uint _num) public {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );

        require(success, "Failed");
    }

}

contract Implementation1{
    uint public num;

    function setNum(uint256 _num) public {
        num = _num;
    }
}

contract Implementation2{
    uint public num;

    function setNum(uint256 _num) public {
        num = 2 * _num;
    }
}