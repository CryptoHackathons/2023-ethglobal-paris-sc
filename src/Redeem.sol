// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

contract Lottery {
    function redeemLotteryPrize2() external nonReentrant {
        uint amount = cryptoLotteryStates[lotteryId].amount;
        address tokenAddress = cryptoLotteryStates[lotteryId].tokenAddress;
        IERC20(tokenAddress).transfer(drawer, amount);
    }
}
