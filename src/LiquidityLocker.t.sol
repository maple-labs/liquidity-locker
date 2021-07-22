pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./LiquidityLocker.sol";

contract LiquidityLockerTest is DSTest {
    LiquidityLocker locker;

    function setUp() public {
        locker = new LiquidityLocker();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
