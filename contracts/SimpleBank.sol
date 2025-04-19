// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => uint) public balances;
    mapping(address => bool) public hasAccess;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    modifier onlyAuthorized() {
        require(msg.sender == owner || hasAccess[msg.sender], "Not authorized");
        _;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }

    function getMyBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function grantAccess(address _user) public onlyOwner {
        hasAccess[_user] = true;
    }

    function revokeAccess(address _user) public onlyOwner {
        hasAccess[_user] = false;
    }

    function destroyContract() public onlyOwner {
        selfdestruct(payable(owner));
    }
}
