// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LoyaltyService {
   
    address tokenOwner;
    ERC20 token;
    uint256 public priceTokenInWei;
    uint256 public availableBalance;

    event Received(address indexed _sender, uint256 _amount, uint indexed _timestamp);
    event Fallbacked(address indexed _sender, uint256 _amount, uint indexed _timestamp);
    event NewPriceToken(uint256 _priceTokenInWei, uint indexed _timestamp);

    constructor(address _token) {
        token = ERC20(_token);
        tokenOwner = msg.sender;
    }

     modifier onlyOwner() {
        require(msg.sender == tokenOwner, "You are not owner");
        _;
    }

    function deposit() public payable onlyOwner {
        availableBalance += msg.value;
        calculatePriceToken();
    }

    function withdraw(address payable _to, uint256 _amount) public onlyOwner {
        require(_amount <= availableBalance, "Available balance not enough");
        availableBalance -= _amount;
        _to.transfer(_amount);
        calculatePriceToken();
    }

    function calculatePriceToken() internal onlyOwner {
        priceTokenInWei = availableBalance / token.balanceOf(tokenOwner);
        emit NewPriceToken(priceTokenInWei, block.timestamp);
    }

    function withdrawContactBalance(address payable _to, uint256 _amount) public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(_amount <= contractBalance, "Balance not enough");
        contractBalance -= _amount;
        _to.transfer(_amount);
    }

    function contactBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function increaseToken() public onlyOwner {
        
    }

    function decreaseToken() public onlyOwner {

    }

    function allowanceToken(address _spender) public view returns(uint256) {
        return token.allowance(tokenOwner, _spender);
    }

    fallback() external payable {
        emit Fallbacked(msg.sender, msg.value, block.timestamp);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value, block.timestamp);
    }
}