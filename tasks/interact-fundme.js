/*
 * @Author: Mr.Car
 * @Date: 2025-07-02 15:15:59
 */
task("interact-fundme", "interact with fundme contract")
    .addParam("addr", "fundme contract address")
    .setAction(async (taskArgs, hre)=>{
        const fundMeFactory = await ethers.getContractFactory("FundMe")
        const fundMe = fundMeFactory.attach(taskArgs.addr)

        // init 2 accounts
        const [firstAccount, secondAccount] = await ethers.getSigners()

        // fund contract with first account
        const fundTx = await fundMe.fund({value: ethers.parseEther("1")})
        await fundTx.wait()

        // check balance of contract
        const balanceOfContract = await ethers.provider.getBalance(fundMe.target)
        console.log(`Balance of the contract is ${balanceOfContract}`)

        // fund contract with second account
        const fundTxWithSecondAccount = await fundMe.connect(secondAccount).fund({value: ethers.parseEther("2")})
        await fundTxWithSecondAccount.wait()

        // check balance of contract
        const balanceOfContractAfterSecondFund = await ethers.provider.getBalance(fundMe.target)
        console.log(`Balance of the contract is ${balanceOfContractAfterSecondFund}`)

        // check mapping 在default模式下报错，因为有chainlink，chainlink 部署在公链上
        const numbersOfFund = await fundMe.numbersOfFund()
        console.log(`numbers of fund is ${numbersOfFund}`)

        const firstAccountbalanceInFundMe = await fundMe.fundersToAmount(firstAccount.address)
        const secondAccountbalanceInFundMe = await fundMe.fundersToAmount(secondAccount.address)
        console.log(`Balance of first account ${firstAccount.address} is ${firstAccountbalanceInFundMe}`)
        console.log(`Balance of Second account ${secondAccount.address} is ${secondAccountbalanceInFundMe}`)
    })