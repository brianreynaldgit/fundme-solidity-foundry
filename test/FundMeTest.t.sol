// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundme;
    function setUp() external {
        fundme = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public{
        // why address(this)?
        // because setup is the one initialize FundMe, not the msg.Sender
        // so if we tried to compare owner by msg.Sender(), it will be wrong
        address msgSender = address(this);
        assertEq(fundme.i_owner(), msgSender);
    }
}