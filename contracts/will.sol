// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Will{
    address private owner;
    address private recipient;

    uint startTime;
    uint  lastVisited;
    uint  tenYears;

    constructor(address _recipient)  {
        tenYears = 10;
        startTime = block.timestamp;
        lastVisited = block.timestamp;

        owner = msg.sender;
        recipient = _recipient;
    }

    modifier isOwner{
        require(owner == msg.sender, "You are not the owner!!");
        _;
    }

    modifier isRecipient{
        require(recipient == msg.sender, "You are not the recipient choosen by the owner!!");
        _;
    }

    function deposit() public payable isOwner {
        lastVisited = block.timestamp;
    }


    function changeRecipient(address newRecipient) public isOwner{
        recipient = newRecipient;
        lastVisited = block.timestamp;
    }

    function ping() public isOwner{
        lastVisited = block.timestamp;
    }

    function drain() public isRecipient payable {
        require(lastVisited < block.timestamp - tenYears);
        payable(recipient).transfer(address(this).balance);
    }

}