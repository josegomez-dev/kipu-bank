// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KipuBank Smart Contract
/// @author Jose Alejandro Gomez Castro / ChatGPT + RemixIA
/// @notice Simple vault for depositing and withdrawing ETH with limits
/// @dev exam module 2

contract KipuBank {
    /// @notice Contract version
    uint256 public constant VERSION = 7;

    /// @notice Max amount allowed per withdrawal
    uint256 public immutable withdrawLimit;

    /// @notice Max total deposits allowed in the bank
    uint256 public immutable bankCap;

    /// @notice Total deposits made into the bank
    uint256 public totalDeposits;

    /// @notice Total withdrawals made from the bank
    uint256 public totalWithdrawals;

    /// @dev User balances mapping
    mapping(address => uint256) private balances;

    /// @dev User deposit count
    mapping(address => uint256) private depositCount;

    /// @dev User withdrawal count
    mapping(address => uint256) private withdrawalCount;

    /// @notice Contract creator address
    address public owner;

    /// @dev Custom error when bank cap exceeded
    error BankCapExceeded();

    /// @dev Custom error when withdrawal limit exceeded
    error WithdrawLimitExceeded();

    /// @dev Custom error when balance is insufficient
    error InsufficientBalance();

    /// @dev Custom error for invalid deposit address
    error InvalidDepositAddress();

    /// @dev Custom error when ETH transfer fails
    error TransferFailed();

    /// @notice Event emitted on deposit
    event Deposit(address indexed user, uint256 amount);

    /// @notice Event emitted on withdrawal
    event Withdrawal(address indexed user, uint256 amount);

    /// @notice Constructor sets deposit and withdrawal limits
    /// @param _withdrawLimit Max amount per withdrawal (in wei)
    /// @param _bankCap Max total ETH allowed in the contract (in wei)
    constructor(uint256 _withdrawLimit, uint256 _bankCap) {
        withdrawLimit = _withdrawLimit;
        bankCap = _bankCap;
        owner = msg.sender;
    }

    /// @dev Modifier to prevent exceeding bank capacity
    modifier notExceedBankCap(uint256 amount) {
        if (totalDeposits + amount > bankCap) revert BankCapExceeded();
        _;
    }

    /// @notice Deposit ETH into another user's vault
    /// @param user Address to deposit for
    function depositTo(address user) external payable notExceedBankCap(msg.value) {
        if (user == address(0)) revert InvalidDepositAddress();
        _deposit(user, msg.value);
    }


    /// @notice Deposit ETH into your own vault
    /// @dev Uses msg.sender and msg.value
    function deposit() external payable notExceedBankCap(msg.value) {
        _deposit(msg.sender, msg.value);
    }

    /// @dev Internal deposit logic
    /// @param user Address of the vault owner
    /// @param amount Amount of ETH to deposit
    function _deposit(address user, uint256 amount) private {
        balances[user] += amount;
        totalDeposits += amount;
        depositCount[user]++;
        emit Deposit(user, amount);
    }

    /// @notice Withdraw ETH from your vault
    /// @param amount Amount to withdraw
    function withdraw(uint256 amount) external {
        if (amount > withdrawLimit) revert WithdrawLimitExceeded();
        if (balances[msg.sender] < amount) revert InsufficientBalance();

        balances[msg.sender] -= amount;
        totalWithdrawals += amount;
        withdrawalCount[msg.sender]++;

        (bool sent, ) = msg.sender.call{value: amount}("");
        if (!sent) revert TransferFailed();

        emit Withdrawal(msg.sender, amount);
    }

    /// @notice Get the balance of a user
    /// @param user The address of the user
    /// @return The ETH balance of the user
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    /// @notice Get how many times a user has deposited
    function getDepositCount(address user) external view returns (uint256) {
        return depositCount[user];
    }

    /// @notice Get how many times a user has withdrawn
    function getWithdrawalCount(address user) external view returns (uint256) {
        return withdrawalCount[user];
    }
}
