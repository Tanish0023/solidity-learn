// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingWithEmissions.sol";
import "src/OrchaCoin.sol";

contract StakingWithEmissionsTest is Test {
    StakingWithEmissions stakingContract;
    OrchaCoin orchaToken;

    function setUp() public {
        orchaToken = new OrchaCoin(address(this));
        stakingContract = new StakingWithEmissions(
            IOrchaCoin(address(orchaToken))
        );
        orchaToken.UpdateContractAddress(address(stakingContract));
    }

    function testStake() public {
        uint amount = 10 ether;
        stakingContract.stake{value: amount}();

        assert(stakingContract.totalStake() == amount);
    }

    function testRevertStake() public {
        uint amount = 10 ether;
        stakingContract.stake{value: amount}();
        
        vm.expectRevert();
        stakingContract.unStake(11 ether);
    }

    function testGetReward() public {
        uint amount = 10 ether;
        stakingContract.stake{value: amount}();
        
        vm.warp(block.timestamp + 1);
        uint reward = stakingContract.getReward();

        assert(reward == 10 ether);
    }

    function testComplexGetRewards() public{
        uint value = 1 ether;
        stakingContract.stake{value: value}();
        vm.warp(block.timestamp + 1);
        console.log(block.timestamp);
        stakingContract.stake{value: value}();
        vm.warp(block.timestamp + 1);
        uint rewards = stakingContract.getReward();

        assert(rewards == 3 ether);
    }

    function testRedeemRewards() public {
        uint value = 1 ether;
        stakingContract.stake{value: value}();
        vm.warp(block.timestamp + 1);
        stakingContract.claimReward();
        console.log("balance of");
        console.log(orchaToken.balanceOf(address(this)));

        assert(orchaToken.balanceOf(address(this)) == 1 ether);
    }
}
