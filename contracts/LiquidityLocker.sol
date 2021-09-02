// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { IERC20, SafeERC20 } from  "../modules/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

import { ILiquidityLocker } from "./interfaces/ILiquidityLocker.sol";
import { ILoanLike }        from "./interfaces/ILoanLike.sol";

/// @title LiquidityLocker holds custody of Liquidity Asset tokens for a given Pool.
contract LiquidityLocker is ILiquidityLocker {

    using SafeERC20 for IERC20;

    address public override immutable pool;
    address public override immutable liquidityAsset;

    constructor(address _liquidityAsset, address _pool) public {
        liquidityAsset = _liquidityAsset;
        pool           = _pool;
    }

    /**
        @dev Checks that `msg.sender` is the Pool.
     */
    modifier isPool() {
        require(msg.sender == pool, "LL:NOT_P");
        _;
    }

    function transfer(address dst, uint256 amt) external override isPool {
        require(dst != address(0), "LL:NULL_DST");
        IERC20(liquidityAsset).safeTransfer(dst, amt);
    }

    function fundLoan(address loan, address debtLocker, uint256 amount) external override isPool {
        IERC20(liquidityAsset).safeApprove(loan, amount);
        ILoanLike(loan).fundLoan(debtLocker, amount);
    }

}
