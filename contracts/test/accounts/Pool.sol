// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { ILiquidityLocker }        from "../../interfaces/ILiquidityLocker.sol";
import { ILiquidityLockerFactory } from "../../interfaces/ILiquidityLockerFactory.sol";

contract Pool {

    /************************/
    /*** Direct Functions ***/
    /************************/

    function liquidityLockerFactory_newLocker(address factory, address token) external returns (address) {
        return ILiquidityLockerFactory(factory).newLocker(token);
    }

    function liquidityLocker_transfer(address locker, address destination, uint256 amount) external {
        ILiquidityLocker(locker).transfer(destination, amount);
    }

    function liquidityLocker_fundLoan(address locker, address loan, address debtLocker, uint256 amount) external {
        ILiquidityLocker(locker).fundLoan(loan, debtLocker, amount);
    }

    /*********************/
    /*** Try Functions ***/
    /*********************/

    function try_liquidityLockerFactory_newLocker(address factory, address token) external returns (bool ok) {
        (ok,) = factory.call(abi.encodeWithSelector(ILiquidityLockerFactory.newLocker.selector, token));
    }

    function try_liquidityLocker_transfer(address locker, address destination, uint256 amount) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSelector(ILiquidityLocker.transfer.selector, destination, amount));
    }

    function try_liquidityLocker_fundLoan(address locker, address loan, address debtLocker, uint256 amount) external returns (bool ok) {
        (ok,) = locker.call(abi.encodeWithSelector(ILiquidityLocker.fundLoan.selector, loan, debtLocker, amount));
    }

}
