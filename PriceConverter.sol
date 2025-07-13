// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    function getPrice() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x4A78dFC52566063f50F8cf4eD52F513AEB866A0C);
        (
            ,
            int256 price,
            ,
            ,
            
        ) = priceFeed.latestRoundData(); // this is the most important thing to understand
        
        // if (price <= 1e18) { 
        //     revert("too low price");
        // } 
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal  view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal  view returns (uint256) {    }
}