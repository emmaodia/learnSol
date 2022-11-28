const { expect } = require("chai");
const hre = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("HelloWorld");
    const greeter = await Greeter.deploy();
    await greeter.deployed();

    expect(await greeter.getGreeting()).to.equal("");

    const setGreetingTx = await greeter.setGreeting("Emmanuel!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.getGreeting()).to.equal("Hello Emmanuel!");
  });
});
