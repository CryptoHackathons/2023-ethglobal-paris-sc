// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/Lottery2.sol";

contract CounterScript is Script {
    function setUp() public {
        console2.log("set");
    }

    function run() public {
        vm.startBroadcast();

        Lottery2 c = new Lottery2();
        vm.stopBroadcast();
    }

    function test(uint256 x) public {
        console2.log("x");
    }
}
