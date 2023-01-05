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
    uint256 tokenPrice;
    mapping(address => bool) public businessOwnerMapping;
    mapping(address => Business) public businessMapping;
    mapping(address => uint256) public balanceMapping;
    uint256 businessIdSeq;

    event RegisterBusiness(
        address indexed _businessOwner,
        uint256 indexed _businessId,
        uint256 _timestamp
    );

    constructor(address _token, uint256 _tokenPrice) {
        token = ERC20(_token);
        tokenOwner = msg.sender;
        tokenPrice = _tokenPrice;
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
        businessMapping[msg.sender] = business;
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
        businessMapping[msg.sender].quantity = _amount;
    }

    function allowanceOf(address _businessOwner) public view returns (uint256) {
        return token.allowance(tokenOwner, _businessOwner);
    }

    function depositBalance() public payable onlyBusinessOwner {
        require(businessOwnerMapping[msg.sender], "Unregistered business");
        balanceMapping[msg.sender] += msg.value;
        updatePriceTokenBusiness(msg.value);
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

    function updatePriceTokenBusiness(address _businessOwner) internal returns (uint256) {
        
    }
}
