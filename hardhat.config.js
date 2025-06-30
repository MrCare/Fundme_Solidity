/*
 * @Author: Mr.Car
 * @Date: 2025-06-28 15:27:07
 */
require("@nomicfoundation/hardhat-toolbox");
require("@chainlink/env-enc").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // defaultNetwork: "hardhat", // 默认使用本地网络
  // networks: {
  //   sepolia: {
  //     url: process.env.SEPOLIA_RPC_URL,
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  // },
  solidity: "0.8.28",
};
