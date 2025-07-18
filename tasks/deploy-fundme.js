/*
 * @Author: Mr.Car
 * @Date: 2025-07-02 14:15:47
 */
task("deploy-fundme").setAction(async (taskArgs, hre)=>{
    // create factory
    const fundMeFactory = await ethers.getContractFactory("FundMe")
    console.log("contract deploying")

    // deploy contract from factory
    const fundMe = await fundMeFactory.deploy(300)
    await fundMe.waitForDeployment()
    console.log(`contract has been deployed successfully, contract address is ${fundMe.target}`)

    // verify fundme
    if(hre.network.config.chainId = 11155111 && process.env.ETHERSCAN_API){
        console.log("Waiting for 5 confirmations")
        await fundMe.deploymentTransaction().wait(5)
        await verifyFundMe(fundMe.target, [300])
    } else {
        console.log("verify skipped...")
    }
})

async function verifyFundMe(fundMeAddr, args) {
    await hre.run("verify:verify", {
        address:fundMeAddr,
        constructorArguments: args
    })
    
}

module.exports = {}