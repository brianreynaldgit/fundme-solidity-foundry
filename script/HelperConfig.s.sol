// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkCfg;
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkCfg = getSepoliaEthCfg();
        } else {
            activeNetworkCfg = getAnvilEthCfg();
        }
    }

    function getSepoliaEthCfg() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function getAnvilEthCfg() public pure returns (NetworkConfig memory) {

    }
}