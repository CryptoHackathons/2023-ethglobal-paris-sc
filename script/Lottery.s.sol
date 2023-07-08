// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "../src/Lottery.sol";

contract CounterScript is Script {
    function setUp() public {
        console2.log("set");
    }

    function run() public {
        vm.startBroadcast();
        address _vrfCoordinator = 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed;
        bytes32 _keyHash = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
        uint64 _subscriptionId = 4203;

        Lottery c = new Lottery(_vrfCoordinator, _keyHash, _subscriptionId);
        vm.stopBroadcast();
    }

    function test(uint256 x) public {
        console2.log("x");
    }
}
