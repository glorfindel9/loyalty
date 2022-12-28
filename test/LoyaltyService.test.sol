// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "forge-std/test.sol";

contract StakeContractTest is Test {

    uint256 testNumber;

    function setUp() public {
        testNumber = 42;
    }

    function testNumberIs42() public {
        assertEq(testNumber, 42);
    }

    function testFailSubtract43() public {
        testNumber -= 43;
    }
}