// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import "@uniswap/lib/contracts/libraries/FullMath.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/lib/contracts/libraries/Babylonian.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol";
import "@uniswap/lib/contracts/libraries/FixedPoint.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract New is Ownable, ReentrancyGuard {
    // Router and factory interfaces
    IUniswapV2Router02 public uniswapRouter;
    IUniswapV2Factory public uniswapFactory;

    // Fee collector address
    address public feeCollector;

    // Events
    event LiquidityProvided(address indexed provider, address tokenA, address tokenB, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, address tokenA, address tokenB, uint256 amountA, uint256 amountB);
    event TokensExchanged(address indexed sender, address[] path, uint256 amountIn, uint256 amountOut);
    event FeeCollected(address indexed feeCollector, uint256 feeAmount);

    // Liquidity struct to store the balance
    struct Liquidity {
        uint256 amountA;
        uint256 amountB;
    }

    // Mapping to store liquidity provided by each user
    mapping(address => mapping(address => Liquidity)) public userLiquidity;

    // Constructor
    constructor(address _uniswapRouter, address _uniswapFactory, address _feeCollector)Ownable(msg.sender){
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
        uniswapFactory = IUniswapV2Factory(_uniswapFactory);
        feeCollector = _feeCollector;
    }

    // Add liquidity to Uniswap with fee handling
    function provideLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        nonReentrant
        returns (uint256 amountA, uint256 amountB, uint256 liquidity)
    {
        // Transfer tokens to contract
        IERC20(_tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(_tokenB).transferFrom(msg.sender, address(this), amountBDesired);

        // Approve the router to spend tokens
        IERC20(_tokenA).approve(address(uniswapRouter), amountADesired);
        IERC20(_tokenB).approve(address(uniswapRouter), amountBDesired);

        // Adding liquidity
        (amountA, amountB, liquidity) = uniswapRouter.addLiquidity(
            _tokenA,
            _tokenB,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            to,
            block.timestamp + deadline
        );

        // Store liquidity for the provider
        userLiquidity[to][_tokenA].amountA += amountA;
        userLiquidity[to][_tokenB].amountB += amountB;

        emit LiquidityProvided(to, _tokenA, _tokenB, amountA, amountB);

        return (amountA, amountB, liquidity);
    }

    // Swap tokens with fee deduction
    function exchangeTokensWithFee(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external nonReentrant {
        // Calculate fee (0.3%)
        uint256 fee = (amountIn * 3) / 1000;
        uint256 amountAfterFee = amountIn - fee;

        // Transfer tokens to contract
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn);

        // Transfer fee to fee collector
        IERC20(path[0]).transfer(feeCollector, fee);
        emit FeeCollected(feeCollector, fee);

        // Approve router to spend the tokens
        IERC20(path[0]).approve(address(uniswapRouter), amountAfterFee);

        // Execute the swap
        uint[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amountAfterFee,
            amountOutMin,
            path,
            to,
            block.timestamp + deadline
        );

        // Emit event for the swap
        emit TokensExchanged(msg.sender, path, amountIn, amounts[amounts.length - 1]);
    }

    // Remove liquidity from Uniswap with fee adjustment
    function withdrawLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        nonReentrant
        returns (uint256 amountA, uint256 amountB)
    {
        // Get the pair address for the tokens
        address pair = uniswapFactory.getPair(_tokenA, _tokenB);

        // Transfer LP tokens to contract
        IERC20(pair).transferFrom(msg.sender, address(this), liquidity);
        IERC20(pair).approve(address(uniswapRouter), liquidity);

        // Remove liquidity
        (amountA, amountB) = uniswapRouter.removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            amountAMin,
            amountBMin,
            to,
            block.timestamp + deadline
        );

        // Adjust user liquidity mapping
        userLiquidity[msg.sender][_tokenA].amountA -= amountA;
        userLiquidity[msg.sender][_tokenB].amountB -= amountB;

        emit LiquidityRemoved(msg.sender, _tokenA, _tokenB, amountA, amountB);

        return (amountA, amountB);
    }

    // Add new pair of supported tokens
    function createPairIfNotExist(address _tokenA, address _tokenB) external onlyOwner {
        address pair = uniswapFactory.getPair(_tokenA, _tokenB);
        if (pair == address(0)) {
            uniswapFactory.createPair(_tokenA, _tokenB);
        }
    }

    // Withdraw ERC20 tokens in case of emergency
    function emergencyWithdraw(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(balance > 0, "No balance available");

        IERC20(token).transfer(msg.sender, balance);
    }

    // Function to update the fee collector address
    function updateFeeCollector(address newFeeCollector) external onlyOwner {
        feeCollector = newFeeCollector;
    }

    // Fallback function to receive Ether
    receive() external payable {}
}
