// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IOrchaCoin {
    function mint(address _account, uint256 _amount) external;
}

contract StakingWithEmissions{
    address owner;
    IOrchaCoin tokenContractAddress;
    uint totalStake;

    uint256 public constant REWARD_PER_SEC_PER_ETH = 1;

    struct UserInfo {
        uint userBalance;
        uint unclaimedReward;
        uint lastUpdated;
    }

    mapping (address => UserInfo) public userInfo;

    constructor(IOrchaCoin _tokenAddress) {
        owner = msg.sender;
        tokenContractAddress = _tokenAddress;
    }

    modifier isOwner{
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function _updateUserInfo(address _userAddress) internal {
        UserInfo storage user = userInfo[_userAddress];

        if (user.lastUpdated == 0) {
            user.lastUpdated = block.timestamp;
            return;
        }

        uint timeSinceLastUpdated = block.timestamp - user.lastUpdated;
        if(timeSinceLastUpdated == 0){
            return;
        }

        uint newReward = timeSinceLastUpdated * user.userBalance * REWARD_PER_SEC_PER_ETH;

        user.unclaimedReward += newReward;
        user.lastUpdated = block.timestamp;
    }

    function stake() public payable{
        require(msg.value > 0, "Amount should be greater than 0");

        _updateUserInfo(msg.sender);
        
        UserInfo storage user = userInfo[msg.sender];
        user.userBalance += msg.value;
        totalStake += msg.value;
    }

    function unStake(uint _amount) public payable{
        require(_amount > 0, "Amount must be greater than 0");

        UserInfo storage user = userInfo[msg.sender];
        require(_amount <= user.userBalance , "You do not have enough balance");

        _updateUserInfo(msg.sender);

        user.userBalance -= _amount;
        totalStake -= _amount;

        payable(msg.sender).transfer(_amount);
    }

    function claimReward() public {
        _updateUserInfo(msg.sender);
        
        UserInfo storage user = userInfo[msg.sender];
        tokenContractAddress.mint(msg.sender, user.unclaimedReward);
        user.unclaimedReward = 0;
    }
    
    function getReward() public view returns (uint) {
        UserInfo storage user = userInfo[msg.sender];

        uint timeSinceLastUpdated = block.timestamp - user.lastUpdated;
        if(timeSinceLastUpdated == 0){
            return user.unclaimedReward;
        }

        uint newReward = timeSinceLastUpdated * user.userBalance * REWARD_PER_SEC_PER_ETH;
        return user.unclaimedReward + newReward;
    }

    function userBalance() public view returns (uint) {
        UserInfo storage user = userInfo[msg.sender];
        return user.userBalance;
    }

    function updateTokenAddress(IOrchaCoin _newTokenAddress) public isOwner{
        tokenContractAddress = _newTokenAddress;
    }

}