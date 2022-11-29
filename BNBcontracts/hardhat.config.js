require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { mnemonic } = process.env.mnemonic

const GETBLOCK_API_KEY = process.env.GETBLOCK_API_KEY;
const BNB_PRIVATE_KEY = process.env.BNB_PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    testnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
      accounts: [`${BNB_PRIVATE_KEY}`],
      // chainId: 97
    },
  },
};
