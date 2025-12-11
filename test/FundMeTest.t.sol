// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        deployFundMe.run();
        fundme = deployFundMe.GetDeployedFundMe();
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public{
        // why address(this)?
        // because setup is the one initialize FundMe, not the msg.Sender
        // so if we tried to compare owner by msg.Sender(), it will be wrong

        // now it changed to deploy using the script, change it back to msg.Sender
        address msgSender = msg.sender;
        assertEq(fundme.i_owner(), msgSender);
    }
}