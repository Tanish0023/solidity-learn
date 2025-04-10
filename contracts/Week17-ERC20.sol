// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract TanishCoin {
    address public owner;
    mapping (address => uint) balances;
    uint public totalCoins=0;

    mapping (address => mapping (address => uint)) allowances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "You are not the owner!");
        _;
    }

    function mint(uint amount) public onlyOwner  {
        balances[owner] += amount;
        totalCoins += amount;
    }

    function mintTo(address receiver, uint amount) public onlyOwner {
        balances[receiver] += amount;
        totalCoins += amount;
    }

    function transfer(address receiver, uint amount) public  {
        require(balances[msg.sender] >= amount, "You do not have enough balance");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }

    function allowanceCreation(address to, uint amount) public {
        require(balances[msg.sender] >= amount, "You do not have enough balance");

        allowances[msg.sender][to] += amount;
    }
}