// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address _from, address _to, uint _amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(uint amount, address receiver) public {
        require(minter == msg.sender);
        balances[receiver] += amount;
    }  

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if( amount > balances[msg.sender]) {
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Sent(msg.sender, receiver, amount);
    }

}