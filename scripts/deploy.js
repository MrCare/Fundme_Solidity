/*
 * @Author: Mr.Car
 * @Date: 2025-06-28 16:29:27
 */
const { ethers } = require("hardhat");

// 自动便写测试脚本：
// create main function
// init 2 accounts
// fund contract with first account
// check balance of contract

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const FundMe = await ethers.getContractFactory("FundMe");
    const fundMe = await FundMe.deploy( 30*24*60*60 ); // 锁定期30天
    await fundMe.waitForDeployment();
    console.log(`Deployed sucessfully, contract address is ${deployer.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
