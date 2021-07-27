// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { ILiquidityLocker } from "../../interfaces/ILiquidityLocker.sol";

import { LiquidityLockerFactory } from "../../LiquidityLockerFactory.sol";

contract LiquidityLockerOwner {

    function liquidityLockerFactory_newLocker(address factory, address token) external returns (address) {
        return LiquidityLockerFactory(factory).newLocker(token);
    }

    function try_liquidityLockerFactory_newLocker(address factory, address token) external returns (bool ok) {
        (ok,) = factory.call(abi.encodeWithSignature("newLocker(address)", token));
    }

    function liquidityLocker_transfer(address locker, address destination, uint256 amount) external {
        ILiquidityLocker(locker).transfer(destination, amount);
    }

    function try_liquidityLocker_transfer(address locker, address destination, uint256 amount) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSignature("transfer(address,uint256)", destination, amount));
    }

    function liquidityLocker_fundLoan(address locker, address loan, address debtLocker, uint256 amount) external {
        ILiquidityLocker(locker).fundLoan(loan, debtLocker, amount);
    }

    function try_liquidityLocker_fundLoan(address locker, address loan, address debtLocker, uint256 amount) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSignature("fundLoan(address,address,uint256)", loan, debtLocker, amount));
    }

}
