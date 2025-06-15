# 🏦 KipuBank Smart Contract

A simple and secure Ethereum-based vault that allows users to deposit and withdraw ETH under customizable limits. Built using Solidity for demonstration purposes as part of Module 2 in the Solidity development course.

View Contract on EtherScan: https://sepolia.etherscan.io/address/0xe79fb757382d52e0a2b781d54ebe6eb65ad096a1

---
## 📌 Overview

KipuBank is a decentralized ETH vault system designed to:

- Allow users to deposit ETH into personal vaults
- Enable controlled withdrawals with a set maximum per transaction
- Prevent the contract from exceeding a maximum total deposit cap
- Emit useful logs for deposit and withdrawal events
- Handle errors using Solidity `custom errors` for gas-efficient feedback

---

## 👨‍💻 Author

**Jose Alejandro Gomez Castro**  
Built with the support of ChatGPT and Remix IDE  
Version: `6`

---

## ⚙️ Features

- `deposit()` → Deposit ETH into your own vault
- `depositTo(address user)` → Deposit ETH into another user's vault
- `withdraw(uint256 amount)` → Withdraw ETH from your vault (up to a fixed limit)
- `getBalance(address user)` → View current balance of any user
- `getDepositCount(address user)` / `getWithdrawalCount(address user)` → View number of interactions
- Safety checks for:
  - Maximum withdrawal per transaction
  - Total contract cap on deposits
  - Invalid addresses
  - ETH transfer failures

---

## 🔐 Constructor Parameters

| Parameter        | Description                            | Example (wei)          |
|------------------|----------------------------------------|------------------------|
| `_withdrawLimit` | Maximum ETH allowed per withdrawal     | `1000000000000000` (0.001 ETH) |
| `_bankCap`       | Maximum total ETH contract can accept  | `100000000000000000` (0.1 ETH) |

---

## 🧪 How to Deploy (Using Remix IDE)

1. Open [https://remix.ethereum.org](https://remix.ethereum.org)
2. Paste the contract into a new file `KipuBank.sol`
3. Compile with Solidity `^0.8.20`
4. Go to **Deploy & Run Transactions** tab:
   - Environment: `Injected Provider - MetaMask`
   - Enter constructor values
   - Deploy using your Sepolia wallet
5. Use `deposit()` or `depositTo(...)` with ETH in the Value field to interact

---

## 💸 Example Test Cases

### ✅ Deposit to Self
1. Set Value = `0.001` ETH or `1000000000000000` wei 
2. Call `deposit()`
3. Check `getBalance(your_address)` → returns `1000000000000000`

### ✅ Deposit to Another User
1. Set Value = `0.002` ETH or `2000000000000000` wei
2. Call `depositTo(wallet_address)`
3. Check `getBalance("wallet_address")` → returns `2000000000000000`

### ✅ Withdraw
1. Call `withdraw(1000000000000000)`
2. ETH is returned to your wallet if under the allowed limit

---

## 📊 Contract State Variables

| Variable         | Description                                      |
|------------------|--------------------------------------------------|
| `totalDeposits`  | Total ETH deposited in contract (in wei)         |
| `totalWithdrawals`| Total ETH withdrawn from contract (in wei)      |
| `balances`       | Mapping of address → current vault balance       |
| `depositCount`   | Mapping of address → number of deposits          |
| `withdrawalCount`| Mapping of address → number of withdrawals       |
| `owner`          | Address that deployed the contract               |

---

## 🚨 Custom Errors

| Error                 | Description                                     |
|------------------------|-------------------------------------------------|
| `BankCapExceeded()`   | Prevents deposits that exceed total cap         |
| `WithdrawLimitExceeded()` | Prevents withdrawals above set max           |
| `InsufficientBalance()` | When user tries to withdraw more than allowed |
| `InvalidDepositAddress()` | When `depositTo()` receives an invalid address |
| `TransferFailed()`    | If ETH transfer fails due to low-level call     |

---

## 🔒 Security Considerations

- Uses `call{value: amount}("")` for ETH transfer safety
- Vaults are isolated per user
- Deposits/Withdrawals are bounded to avoid abuse
- Follows best practices with immutable variables and constructor setup
- Uses efficient `custom errors` for gas savings

---

## 📜 License

MIT License  
(C) 2025 - Jose Alejandro Gomez Castro

---

## 💬 Feedback

If you're reviewing this contract as part of the exam or for learning purposes, feel free to reach out via GitHub or Remix support channels for further questions.

