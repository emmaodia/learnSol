// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Escrow {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Inactive }
    State public state;

    modifier condition(bool _condition){
        require(_condition);
        _;
    }

    error OnlyBuyer();
    error OnlySeller();
    error InvalidState();
    error ValueNotEven();

    modifier onlyBuyer(){
        if(msg.sender != buyer)
        revert OnlyBuyer();
        _;
    }

    modifier onlySeller() {
        if(msg.sender != seller)
        revert OnlySeller();
        _;
    }

    event Aborted();
    event ItemReceived();
    event PurchaseConfirmed();
    event SellerRefunded();
}