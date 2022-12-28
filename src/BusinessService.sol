// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BusinessService {
    struct Business {
        uint256 id;
        address businessOwner;
        uint256 quantity;
        uint256 priceInWei;
    }
    address tokenOwner;
    ERC20 token;
    mapping(address => bool) public businessOwnerMapping;
    mapping(address => Business) businesseMapping;
    mapping(address => uint256) public balanceMapping;
    uint256 businessIdSeq;

    event RegisterBusiness(
        address indexed _businessOwner,
        uint256 indexed _businessId,
        uint256 _timestamp
    );

    constructor(address _token) {
        token = ERC20(_token);
        tokenOwner = msg.sender;
    }

    modifier onlyTokenOwner() {
        require(msg.sender == tokenOwner, "You are not token owner");
        _;
    }

    modifier onlyBusinessOwner() {
        require(businessOwnerMapping[msg.sender], "You are not business owner");
        _;
    }

    function registerBusiness() public {
        uint256 businessId = ++businessIdSeq;
        Business memory business = Business(businessId, msg.sender, 0, 0);
        businesseMapping[msg.sender] = business;
        businessOwnerMapping[msg.sender] = true;
        emit RegisterBusiness(msg.sender, businessId, block.timestamp);
    }

    function allowanceBusiness(
        address _businessOwner,
        uint256 _amount
    ) public onlyTokenOwner{
        require(businessOwnerMapping[_businessOwner], "Unregistered business");
        require(
            token.balanceOf(tokenOwner) > _amount,
            "Exceed available token"
        );
        token.increaseAllowance(_businessOwner, _amount);
        businesseMapping[msg.sender].quantity = _amount;
    }

    function allowanceOf(address _businessOwner) public view returns (uint256) {
        return token.allowance(tokenOwner, _businessOwner);
    }

    function depositBalance() public payable onlyBusinessOwner{
        balanceMapping[msg.sender] = msg.value;
        
    }

    // function previewDeposit() public {}

    function withdrawBalance(address payable _to, uint256 _amount) public onlyBusinessOwner{
        require(_amount <= balanceMapping[_to], "Balance not enough");
        balanceMapping[_to] -= _amount;
        _to.transfer(_amount);
    }

    // function previewWithdraw() public {}

    // function refeshPriceToken() internal {
    //     uint256 price = calculatePriceToken();
    // }

    // function calculatePriceToken() internal returns (uint256) {}
}
