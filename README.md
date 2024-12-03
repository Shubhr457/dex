# MyDEX: Decentralized Exchange Smart Contract
verified Contract :- https://amoy.polygonscan.com/address/0xFf51772D8aC61532D093cf7A0324433fdB1ae6ad#code

## Overview
**MyDEX** is a decentralized exchange (DEX) platform implemented using Solidity. It leverages the Uniswap V2 protocol to enable users to swap tokens, add/remove liquidity, and manage token pairs securely. The contract is designed to be robust, efficient, and extendable for a variety of use cases in the DeFi ecosystem.

This project is educational, demonstrating the functionality of a decentralized exchange while maintaining a unique structure distinct from existing implementations like Uniswap or other similar contracts.

## Features
1. **Add Liquidity**: 
   - Users can provide liquidity to token pairs and receive liquidity pool (LP) tokens in return.
2. **Remove Liquidity**:
   - Liquidity providers can withdraw their token pairs from the pool.
3. **Token Swapping**:
   - Enables swapping between two tokens via Uniswap's router.
4. **Custom Fee Mechanism**:
   - A 0.3% fee is implemented for token swaps, which is collected and sent to a fee collector address.
5. **Emergency Withdraw**:
   - Provides a mechanism for users to withdraw tokens directly from the contract in emergencies.
6. **Pair Management**:
   - Supports the creation and tracking of token pairs via Uniswap's factory.
7. **Events for Transparency**:
   - Emits events for every liquidity addition/removal, token swap, and emergency withdrawal.

---

## Prerequisites
Before deploying or testing this contract, ensure you have the following:
- **Remix IDE**: A browser-based Solidity development environment.
- **MetaMask Wallet**: To interact with the deployed contract.
- **Testnet Tokens**: ERC20 tokens (e.g., Token A and Token B) deployed on the same testnet as the contract.
- **Uniswap V2 Contracts**:
  - **Router**: Deployed Uniswap V2 router contract.
  - **Factory**: Deployed Uniswap V2 factory contract.

---

## Contract Structure

### Dependencies
- **OpenZeppelin Contracts**:
  - `Ownable`: Manages ownership for administrative tasks.
  - `ReentrancyGuard`: Prevents reentrancy attacks.
- **Uniswap V2 Interfaces**:
  - `IUniswapV2Router02`: For interaction with Uniswap's router.
  - `IUniswapV2Factory`: For token pair management.

### Key Components
1. **Constructor**: 
   Initializes the contract by setting the Uniswap router, factory, and fee collector addresses.
   ```solidity
   constructor(
       address _uniswapRouterAddress,
       address _uniswapFactoryAddress,
       address _feeCollector
   ) Ownable(msg.sender) {
       uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
       uniswapFactory = IUniswapV2Factory(_uniswapFactoryAddress);
       feeCollector = _feeCollector;
   }
   ```

2. **Core Functions**:
   - `addLiquidity`: Adds liquidity for a given token pair.
   - `removeLiquidity`: Removes liquidity from a token pair.
   - `swapTokensWithFee`: Swaps tokens and deducts a fee.
   - `addSupportedPair`: Tracks supported token pairs.
   - `emergencyWithdraw`: Allows users to withdraw tokens directly from the contract.

3. **Events**:
   - Events are emitted for liquidity addition/removal, token swaps, and emergency withdrawals to provide transparency.

---

## Testing the Contract on Remix

### Step 1: Deployment
1. **Load Contract in Remix**:
   - Copy the contract into the Remix IDE.
2. **Set Compiler**:
   - Use Solidity compiler version `^0.8.0`.
3. **Deploy the Contract**:
   - Input the following constructor arguments:
     - `_uniswapRouterAddress`: Address of the Uniswap V2 router.
     - `_uniswapFactoryAddress`: Address of the Uniswap V2 factory.
     - `_feeCollector`: Address where swap fees will be collected (can be your wallet address).
   - Click **Deploy**.

### Step 2: Testing Functions

#### 1. **Add Liquidity**
   - Call `addLiquidity` with the following inputs:
     - `_tokenA`: Address of Token A.
     - `_tokenB`: Address of Token B.
     - `amountADesired`: Token A amount (e.g., `1000`).
     - `amountBDesired`: Token B amount (e.g., `2000`).
     - `amountAMin`: Minimum Token A amount (e.g., `900`).
     - `amountBMin`: Minimum Token B amount (e.g., `1800`).
     - `to`: Your wallet address.
     - `deadline`: A future timestamp (e.g., `block.timestamp + 300`).
   - Ensure you approve the contract to spend tokens using `IERC20.approve`.

#### 2. **Remove Liquidity**
   - Call `removeLiquidity` with the following inputs:
     - `_tokenA`: Address of Token A.
     - `_tokenB`: Address of Token B.
     - `liquidity`: Amount of LP tokens to remove.
     - `amountAMin`: Minimum Token A amount to withdraw.
     - `amountBMin`: Minimum Token B amount to withdraw.
     - `to`: Your wallet address.
     - `deadline`: A future timestamp.

#### 3. **Swap Tokens with Fee**
   - Call `swapTokensWithFee` with the following inputs:
     - `amountIn`: Amount of input tokens (e.g., `500`).
     - `amountOutMin`: Minimum amount of output tokens (e.g., `400`).
     - `path`: Token swap path (e.g., `[TokenA, TokenB]`).
     - `to`: Your wallet address.
     - `deadline`: A future timestamp.

#### 4. **Emergency Withdraw**
   - Call `emergencyWithdraw` with the following inputs:
     - `token`: Address of the token to withdraw.

#### 5. **Add Supported Pair**
   - Call `addSupportedPair` with the following inputs:
     - `_tokenA`: Address of Token A.
     - `_tokenB`: Address of Token B.

#### 6. **Get Supported Pairs**
   - Call `getSupportedPairs` to view the tracked token pairs.

---

## Example Inputs for Testing
- **_uniswapRouterAddress**: `0xYourRouterAddress`
- **_uniswapFactoryAddress**: `0xYourFactoryAddress`
- **_feeCollector**: `0xYourWalletAddress`
- **_tokenA**: `0xAddressOfTokenA`
- **_tokenB**: `0xAddressOfTokenB`

### Example Usage
- Add liquidity:
  ```json
  {
    "_tokenA": "0xTokenA",
    "_tokenB": "0xTokenB",
    "amountADesired": "1000",
    "amountBDesired": "2000",
    "amountAMin": "900",
    "amountBMin": "1800",
    "to": "0xYourWallet",
    "deadline": "block.timestamp + 300"
  }
  ```

- Swap tokens:
  ```json
  {
    "amountIn": "500",
    "amountOutMin": "400",
    "path": ["0xTokenA", "0xTokenB"],
    "to": "0xYourWallet",
    "deadline": "block.timestamp + 300"
  }
  ```

---

## Deployment Notes
- Ensure all required token contracts (Token A and Token B) are deployed on the same network.
- Approve the MyDEX contract to spend tokens before calling liquidity or swap functions.

---

## License
This project is licensed under the **MIT License**.

