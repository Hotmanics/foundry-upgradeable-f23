// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTests is Test {
    DeployBox deployer;
    UpgradeBox upgrader;

    address public OWNER = makeAddr("owner");

    BoxV1 public boxV1;

    address public proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run();
    }

    function testBoxWorks() public {
        address proxyAddress = deployer.deployBox();
        uint256 expectedValue = 1;
        assertEq(expectedValue, BoxV1(proxyAddress).version());
    }

    function testUpgrades() external {
        BoxV2 box2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(box2));
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());
    }
}
