// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract {
    mapping(address => uint) userStakeBalance;
    mapping(address => uint) unclaimedReward;
    mapping(address => uint) lastUpdatedTime;

    address tokenAddress;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function stake() public payable {
        require(msg.value > 0, "Amount should be greater than 0");

        if (lastUpdatedTime[msg.sender] == 0) {
            lastUpdatedTime[msg.sender] = block.timestamp;
        } else {
            unclaimedReward[msg.sender] +=
                (block.timestamp - lastUpdatedTime[msg.sender]) *
                userStakeBalance[msg.sender];
            lastUpdatedTime[msg.sender] = block.timestamp;
        }

        userStakeBalance[msg.sender] += msg.value;
    }

    function unstake(uint256 _amount) public {
        require(_amount <= userStakeBalance[msg.sender], "Not enough balance");

        unclaimedReward[msg.sender] +=
            (block.timestamp - lastUpdatedTime[msg.sender]) *
            userStakeBalance[msg.sender];
        lastUpdatedTime[msg.sender] = block.timestamp;

        payable(msg.sender).transfer(_amount);
        userStakeBalance[msg.sender] -= _amount;
    }

    function tokenAddressUpdate(address _newAddress) public isOwner {
        tokenAddress = _newAddress;
    }

    function claimRewards() public {
        uint256 currentReward = unclaimedReward[msg.sender];
        uint256 lastUpdated = lastUpdatedTime[msg.sender];
        uint256 newReward = (block.timestamp - lastUpdated) *
            balanceOf(msg.sender);

        // Transfering Now

        unclaimedReward[msg.sender] = 0;
        lastUpdatedTime[msg.sender] = block.timestamp;
    }

    function getReward(address _userAddress) public view returns (uint) {
        uint256 currentReward = unclaimedReward[_userAddress];
        uint256 lastUpdated = lastUpdatedTime[_userAddress];
        uint256 newReward = (block.timestamp - lastUpdated) *
            balanceOf(_userAddress);

        return currentReward + newReward;
    }

    function balanceOf(address _userAddress) public view returns (uint) {
        return userStakeBalance[_userAddress];
    }
}
