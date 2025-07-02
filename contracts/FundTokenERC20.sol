// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./Fundme.sol";
// ERC20 实现
// 1. 通证的名字
// 2. 通证的简称
// 3. 通证的发行量
// 4. owner的地址
// 5. balance address => uint256

// mint:通证获取
// transfer:transfer通证
// balanceOf:查看某一地址的通证数量

// 子合约的重载
// 1. 让 FundMe 的参与者基于 mapping 来领取通证
// 2. 通证可以转移
// 3. 使用完成后需要 burn 掉

contract FundTokenERC20 is ERC20 {
    FundMe fundMe;
    constructor(address fundMeAddr) ERC20("FundTokenERC20","FT"){
        fundMe = FundMe(fundMeAddr);
    }

    function mint(uint256 amountToMint) public {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint, "Can not mint this money tokens");
        require(fundMe.fundSuccess(), "The fundme is not completed yet");
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
        _mint(msg.sender, amountToMint);

    }

    function claim(uint256 amountToClaim) public {
        // complete claim
        require(balanceOf(msg.sender) >= amountToClaim, "You don't have enough ERC20 tokens");
        // 其它逻辑
        // burn Token
        _burn(msg.sender, amountToClaim);
    }

}