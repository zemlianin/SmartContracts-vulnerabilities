// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/05_CallMeMaybe/CallMeMaybe.sol";
import "src/05_CallMeMaybe/Attacker.sol";

// forge test --match-contract CallMeMaybeTest -vvvv
contract CallMeMaybeTest is BaseTest {
    CallMeMaybe instance;

    function setUp() public override {
        super.setUp();
        payable(user1).transfer(0.01 ether);
        instance = new CallMeMaybe{value: 0.01 ether}();
    }
// Для обхода защиты по высчитываю размера кода, можно использовать вызов функций внутри конструктора.
    function testExploitLevel() public {
        Attacker attacker = new Attacker(address(instance));

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}