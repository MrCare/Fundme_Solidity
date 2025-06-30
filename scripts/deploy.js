/*
 * @Author: Mr.Car
 * @Date: 2025-06-28 16:29:27
 */
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const FundMe = await ethers.getContractFactory("FundMe");
    const fundMe = await FundMe.deploy();
    await fundMe.waitForDeployment();
    console.log(`Deployed sucessfully, contract address is ${deployer.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
