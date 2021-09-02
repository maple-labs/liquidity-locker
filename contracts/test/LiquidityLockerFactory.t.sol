// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";
import { ERC20 }  from "../../modules/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { ILiquidityLocker } from "../interfaces/ILiquidityLocker.sol";

import { LiquidityLockerFactory } from "../LiquidityLockerFactory.sol";

import { Pool } from "./accounts/Pool.sol";

contract MockToken is ERC20 {

    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

}

contract MockLoan {

    function fundLoan(address debtLocker, uint256 amount) external {}

}

contract LiquidityLockerFactoryTest is DSTest {

    function test_newLocker() external {
        LiquidityLockerFactory factory = new LiquidityLockerFactory();
        MockLoan               loan    = new MockLoan();
        MockToken              token   = new MockToken("TKN", "TKN");
        Pool                   pool    = new Pool();
        Pool                   notPool = new Pool();

        ILiquidityLocker locker = ILiquidityLocker(pool.liquidityLockerFactory_newLocker(address(factory), address(token)));

        // Validate the storage of factory.
        assertEq(factory.owner(address(locker)), address(pool), "Invalid owner");
        assertTrue(factory.isLocker(address(locker)),           "Invalid isLocker");

        // Validate the storage of locker.
        assertEq(locker.pool(),                    address(pool),  "Incorrect loan address");
        assertEq(address(locker.liquidityAsset()), address(token), "Incorrect address of liquidity asset");

        // Assert that only the LiquidityLocker owner (pool) can access funds
        token.mint(address(locker), 10);
        assertTrue(!notPool.try_liquidityLocker_transfer(address(locker), address(pool), 1),             "Transfer succeeded from notPool");
        assertTrue(    pool.try_liquidityLocker_transfer(address(locker), address(pool), 1),             "Transfer failed from pool");
        assertTrue(!notPool.try_liquidityLocker_fundLoan(address(locker), address(loan), address(1), 9), "Fund loan succeeded from notPool");
        assertTrue(    pool.try_liquidityLocker_fundLoan(address(locker), address(loan), address(1), 9), "Fund loan failed from pool");
    }

}
