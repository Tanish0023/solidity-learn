// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


contract StakingContract{
    uint256 public totalStake;
    mapping(address => uint256) userStakeBalance;
    address tokenAddress;
    address owner;

    constructor(){
        totalStake = 0;
        owner = msg.sender;
    }

    modifier isOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }


    function stake() public payable{
        require(msg.value>0, "Amount should be greater than 0");
        totalStake += msg.value;
        userStakeBalance[msg.sender] += msg.value;
    }

    function unstake(uint256 _amount) public {
        require(_amount <= userStakeBalance[msg.sender], "Not enough balance");
        payable(msg.sender).transfer(_amount);
        totalStake -= _amount;
        userStakeBalance[msg.sender] -= _amount;
    }

    function tokenAddressUpdate(address _newAddress) public isOwner{
        tokenAddress = _newAddress;
    }

    function claimRewards(uint256 amount) public {
        // tokenAddress.
    }

}