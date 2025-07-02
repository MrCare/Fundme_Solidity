// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1. 创建收款函数
// 2. 记录投资人并查看
// 3. 在锁定期内，达到目标值，生产商可以提款
// 4. 在锁定期内，未达到目标值，投资人在锁定期后可以退款
// 5. 生产商可以转交取款权，获得取款权的人可以提款

contract FundMe {
    mapping (address => uint256) public fundersToAmount;
    uint256 constant MINIMUM_VALUE = 1 * 10 ** 18; // 最小金额 $1 (用 1e18 表示)
    AggregatorV3Interface internal dataFeed;
    uint256 constant TARGET_VALUE = 1000 * 10 ** 18; // 目标金额 $100 (用 1e18 表示)
    address public owner;
    uint256 deploymentTimestamp; // 部署时间
    uint256 lockTime; // 锁定期
    address erc20Addr; // 与此合约交互的通证合约地址
    bool public fundSuccess = false; // 标志此次众筹是否成功，当 getFund 被调用时意味着众筹成功
    /**
     * Network: Sepolia
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */
    constructor(uint256 _lockTime) {
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        ); // spolia 网络的 ETH/USD 价格
        owner = msg.sender;
        deploymentTimestamp = block.timestamp; // 当前区块打包时间戳
        lockTime = _lockTime;
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
    function convertEthToUsd(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        // Chainlink 价格有 8 位小数, ethAmount (msg.value) 是 wei (18位小数)
        // 计算结果是美元价值，也用18位小数表示
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10**8;
        return ethAmountInUsd;
    }

    function fund() external payable {
        require(convertEthToUsd(msg.value) > MINIMUM_VALUE, "You need to spend more ETH!");
        require(block.timestamp < deploymentTimestamp + lockTime, "The project is locked!");
        fundersToAmount[msg.sender] += msg.value;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setFunderToAmount(address funder, uint256 amountToUpdate) external {
        require(msg.sender == erc20Addr, "you don't have permission to call this function");
        fundersToAmount[funder] = amountToUpdate;
    }
    function setErc20Addr(address _erc20Addr) public onlyOwner{
        erc20Addr = _erc20Addr;
    }

    function getFund() external windowClosed onlyOwner {
        require(convertEthToUsd(address(this).balance) >= TARGET_VALUE, "The project is not successful!");

        // payable(msg.sender).transfer(address(this).balance);
        bool success;
        (success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transfer failed!");
        fundSuccess = true;
    }

    function withdraw() external windowClosed {
        // 用于超过锁定期内且没有达到目标值的情况下，取回资金
        require(convertEthToUsd(address(this).balance) < TARGET_VALUE, "The project is successful!");
        require(fundersToAmount[msg.sender] > 0, "You have not funded!");
        uint256 amount = fundersToAmount[msg.sender];
        fundersToAmount[msg.sender] = 0; // 先清零避免重入攻击
        bool success;
        (success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed!");
    }

    modifier windowClosed() {
        require(block.timestamp >= deploymentTimestamp + lockTime, "The project is still locked!");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }
}