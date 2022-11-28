//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract HelloWorld {
    address public owner;
    string greeting;

    constructor() {
        owner = msg.sender;
    }

    function setGreeting(string memory _greeting) public {
        string memory s = "Hello ";
        greeting = string.concat(s, _greeting);
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}
