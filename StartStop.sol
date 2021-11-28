
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract StartStopUpdateExample {

    // Set a storage variable to the address that deployed the Smart Contract
    address public owner;
    bool public paused;


    constructor() {
        // msg.sender is the address of the person who deployed the SC
        owner = msg.sender;
    }

    function sendMoney() public payable {

    }

    function setPaused(bool _paused) public {
        // Of course, this doesn't make much sense, other than being some sort of academic example. BUT! It makes sense
        // if you think of more complex functionality, like a Token Sale that can be paused.
        //  If you have require(paused == false) in all your customer facing functions,
        // then you can easily pause a Smart Contract.
        require(msg.sender == owner, "You are not the owner");
        paused = _paused;
    }

    function withdrawAllMoney(address payable _to) public {
        // Make sure that the person interacting is the same as the one who deployed the SC

        // this is how you trigger Errors (or throw Exceptions) in Solidity
        // If the require evaluates to false it will stop the transaction,
        // roll-back any changes made so far and emit the error message as String
        require(owner == msg.sender, "You cannot withdraw.");

        require(paused == false, "Contract Paused");

        _to.transfer(address(this).balance);
    }
}