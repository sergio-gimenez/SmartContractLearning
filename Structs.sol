//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract MappingsExample {
    // Rule of thumb: Do only the most necessary functions on the blockchain, and everything else off-chain.
    // But for sake of explaining Structs, we will track every single payment in the greatest
    // detail possible with our Smart Contract.

    // structs are initialized with their default value
    struct Payment {
        uint256 amount;
        uint256 timestamp;
    }

    struct Balance {
        uint256 totalBalance;
        uint256 numPayments;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balanceReceived;

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sendMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;

        Payment memory payment = Payment(msg.value, block.timestamp);
        balanceReceived[msg.sender].payments[
            balanceReceived[msg.sender].numPayments
        ] = payment;
        balanceReceived[msg.sender].numPayments++;
    }

    // We will allow only withdrawals for previously done deposits.
    function withdrawMoney(address payable _to, uint256 _amount) public {
        require(
            _amount <= balanceReceived[msg.sender].totalBalance,
            "not enough funds"
        );
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }

    function withdrawAllMoney(address payable _to) public {
        // Checks-Effects-Interaction pattern
        // https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html
        uint256 balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
}
