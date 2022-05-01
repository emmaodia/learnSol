// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Data_Types {

// The is a state variable address with name deployer. It is set to public and can be called from within the contract.
address public deployer;

//Arrays: An array can be dynamic or of fixed length
uint[] public myArray; //Dynamic Array

uint[5] public anArray; //Fixed Array that can only contain 5 items.

mapping(address => uint) balances; //think of mapping like tables, this a table called balances, holding EOA, each called by an unsigned integer
}
