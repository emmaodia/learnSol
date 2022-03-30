// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SimplePayment {
    address public sender;
    address payable public recipient;
    uint256 public expiration;

    constructor (address payable _recipient, uint256 duration) payable {
        sender =  msg.sender;
        recipient = _recipient;
        expiration = block.timestamp + duration;
    }


}