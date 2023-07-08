// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    error CustomError(string message);
    event MyEvent(address indexed sender, uint256 indexed number);
    Counter public counter;
    address public alice;
    Helper public h;

    IERC20 public dai;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        h = new Helper();

        alice = address(0x1242352351);
        dai = IERC20(vm.envAddress("DAI"));
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testEmit() public {
        vm.expectEmit(false, false, false, false);
        emit MyEvent(msg.sender, 123);
        h.emitIt();
    }

    function testRevert() public {
        vm.expectRevert(
            abi.encodeWithSelector(Helper.CustomError.selector, "some reason")
        );
        h.revertIt();
    }
}

contract Helper {
    error CustomError(string message);
    event MyEvent(address indexed sender, uint256 indexed number);

    function whoCalled() public view returns (address) {
        return msg.sender;
    }

    function emitIt() public {
        emit MyEvent(msg.sender, 123);
    }

    function revertIt() public {
        revert CustomError("some reason");
    }
}
