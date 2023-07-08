// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {
        console2.log("set");
    }

    function run() public {
        vm.startBroadcast();
        Counter c = new Counter();
        vm.stopBroadcast();
    }

    function test(uint256 x) public {
        console2.log("x");
    }
}
