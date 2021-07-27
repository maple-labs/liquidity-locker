// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";
import { ERC20 }  from "../../modules/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { ILiquidityLocker } from "../interfaces/ILiquidityLocker.sol";

import { LiquidityLockerFactory } from "../LiquidityLockerFactory.sol";

import { LiquidityLockerOwner } from "./accounts/LiquidityLockerOwner.sol";

contract MintableToken is ERC20 {

    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

}

// NOTE: FundableLoan exists to prevent circular dependency tree.
contract FundableLoan {

    function fundLoan(address debtLocker, uint256 amount) external {}

}

contract LiquidityLockerFactoryTest is DSTest {

    function test_newLocker() external {
        LiquidityLockerFactory factory  = new LiquidityLockerFactory();
        MintableToken          token    = new MintableToken("TKN", "TKN");
        LiquidityLockerOwner   owner    = new LiquidityLockerOwner();
        LiquidityLockerOwner   nonOwner = new LiquidityLockerOwner();
        FundableLoan           loan     = new FundableLoan();

        ILiquidityLocker locker = ILiquidityLocker(owner.liquidityLockerFactory_newLocker(address(factory), address(token)));

        // Validate the storage of factory.
        assertEq(factory.owner(address(locker)), address(owner), "Invalid owner");
        assertTrue(factory.isLocker(address(locker)),            "Invalid isLocker");

        // Validate the storage of locker.
        assertEq(locker.pool(),                    address(owner), "Incorrect loan address");
        assertEq(address(locker.liquidityAsset()), address(token), "Incorrect address of liquidity asset");

        // Assert that only the LiquidityLocker owner can access funds
        token.mint(address(locker), 10);
        assertTrue(!nonOwner.try_liquidityLocker_transfer(address(locker), address(owner), 1),            "Transfer succeeded from nonOwner");
        assertTrue(    owner.try_liquidityLocker_transfer(address(locker), address(owner), 1),            "Transfer failed from owner");
        assertTrue(!nonOwner.try_liquidityLocker_fundLoan(address(locker), address(loan), address(1), 9), "Fund loan succeeded from nonOwner");
        assertTrue(    owner.try_liquidityLocker_fundLoan(address(locker), address(loan), address(1), 9), "Fund loan failed from owner");
    }

}
