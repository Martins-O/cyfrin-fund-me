// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        //Have a minimum $ sent
        // 1. How do we send ETH to this contract
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough fund");
        // msg.value.getConversionRate();
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            // addressToAmountFunded[funder] -= addressToAmountFunded[funder].getConversionRate();
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //transfer
        // payable(msg.sender).transfer(addressToAmountFunded[msg.sender]);
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // call
        // Call.value is the amount we want to transfer
        (bool callSuccess, ) = address(this).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner {
        require(msg.sender == i_owner, "Not Owner");
        _;

    }
}