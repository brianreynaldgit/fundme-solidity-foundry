// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER  = makeAddr("user");
    uint256 constant SEND_VALUE=1e18;
    uint256 constant STARTING_BALANCE=10e18;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, 10e18);
    }

    function testMinimumUsd() external {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() external {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testGetVersionAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }

    function testFundFailsNotEnoughEth() public{
        vm.expectRevert();
        fundMe.fund();
    }
    modifier fundedUser(){
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;

    }

    function testFundGiveFundSuccess() public fundedUser {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public fundedUser{
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }


    function testOnlyOwnerCanWithdraw() public fundedUser {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public fundedUser {
        uint256 startingOwnerBalance =  fundMe.getOwner().balance; 
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance =  fundMe.getOwner().balance; 
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public fundedUser {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex=1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders;i++) {
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
        }
        
        uint256 startingOwnerBalance =  fundMe.getOwner().balance; 
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance =  fundMe.getOwner().balance; 
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }
}
