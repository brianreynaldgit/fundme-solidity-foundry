// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    FundMe fundme;
    function run() external {
        vm.startBroadcast();
        fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.stopBroadcast();
    }

    function GetDeployedFundMe() public returns (FundMe) {
        return fundme;
    }
}