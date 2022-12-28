// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./BusinessService.sol";

contract LoyaltyService {
    
    BusinessService businessService;

    mapping(address => uint256) public allowanceCustomer;

    constructor(address _businessService) {
        businessService = _businessService;
    }

    // TODO something
}