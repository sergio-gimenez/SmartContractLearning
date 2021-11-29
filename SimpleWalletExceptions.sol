//SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

contract ExceptionExample {
    // simplistic wallet contract

    mapping(address => uint256) public balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint64(msg.value));
        balanceReceived[msg.sender] += msg.value;
        assert(balanceReceived[msg.sender] >= uint64(msg.value));
    }

    function withdrawMoney(address payable _to, uint256 _amount) public {
        // Require allows as to throw an exception with a message on it.
        // Useful for giving feedback back to the user.
        require(
            _amount <= balanceReceived[msg.sender],
            "Not Enough Funds, aborting"
        );
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}
