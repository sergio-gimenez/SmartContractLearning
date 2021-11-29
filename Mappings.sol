//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract MappingsExample {
    mapping(address => uint256) public balanceReceived;

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sendMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    // We will allow only withdrawals for previously done deposits.
    function withdrawMoney(address payable _to, uint256 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "not enough funds");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

    function withdrawAllMoney(address payable _to) public {
        // Checks-Effects-Interaction pattern
        // https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html
        uint256 balanceToSend = balanceReceived[msg.sender];
        balanceReceived[msg.sender] = 0;
        _to.transfer(balanceToSend);
    }
}
