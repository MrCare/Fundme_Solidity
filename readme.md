<!--
 * @Author: Mr.Car
 * @Date: 2025-06-28 14:49:36
-->
## background
一个完整的智能合约工程：以众筹业务为核心，包含需求管理，开发，部署和测试，兼顾良好的可扩展性与迭代； 

## 业务模型

角色：发起人 + 参与者

1. 众筹本质上是一个向大家要钱，进而完成共同目标的过程。
2. 发起人宣告自己要完成的目标和计划，以及预计想通过众筹得到的钱。
3. 参与者有意参与后向众筹账户转账，得到纪念通证。
4. 筹款满足目标之后，发起人可以将账户余额提现用于项目使用。
5. 项目成功后，经发起人开启回馈事件后，参与者可凭纪念通证换取产品
6. 项目失败后，经发起人开启回馈事件后，如果尚有结余，众筹者可凭纪念通证将结余取出，直至没有为止

## 智能合约设计

- 状态：
    - 众筹总金额
    - 当前阶段（筹款中，筹款完成，回馈中）
- 函数：
    - 筹款：参与者调用
    - 提款：发起人调用
    - 回馈：发起人调用
    - 赎回：参与者调用

## 构建步骤
```
# 项目初始化
npm init
npm install -D hardhat
npx hardhat

# 合约编译
npx hardhat compile 

# 合约部署
npx hardhat run scripts/deploy.js
```
- spolia 网络配置
    - 节点的 url 在 Alchemy 中获取
    - 私钥使用 @chainlink/env-enc 加密

- 部署脚本可以写成 `task` 脚本并使用 `npx hardhat` 直接调用

## 一些tips

1. `contract.deployed()` 是AI瞎逼的，`contract.waitForDeployment()` 才是正确的;
2. Hardhat 提供了一个本地网络用于智能合约的部署，可通过 `JSON-rpc` 和 `WebSocket`进行通信；