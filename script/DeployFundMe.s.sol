// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundme;
    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkCfg();
        vm.startBroadcast();
        fundme = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
    }

    function GetDeployedFundMe() public returns (FundMe) {
        return fundme;
    }
}