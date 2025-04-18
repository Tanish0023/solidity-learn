// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


import "forge-std/Test.sol";

import "src/StakingContract.sol";

contract StackContractTest is Test {
    StakingContract c;

    receive() external payable {}


    function setUp() public {
        c = new StakingContract();
    }

    function testStake() public {
        uint value = 10 ether;
        c.stake{value: value}();
    }

    function testUnStake() public{
        uint value = 10 ether;
        c.stake{value: value}();
        c.unstake(value);
        // vm.expectRevert();
    }
}
