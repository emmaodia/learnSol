// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage {
    uint StoredData;

    function set(uint x) public {
        StoredData = x;
    }

    function get() public view returns (uint){
        return StoredData;
    }
}

/**
A contract in the sense of Solidity is a collection of code (its functions) and data (its state) 
that resides at a specific address on the Ethereum blockchain. 
The line uint storedData; declares a state variable called storedData of type uint (unsigned integer of 256 bits). 
You can think of it as a single slot in a database that you can query and alter by calling functions of the code that manages the database. 
In this example, the contract defines the functions set and get that can be used to modify or retrieve the value of the variable.
 */