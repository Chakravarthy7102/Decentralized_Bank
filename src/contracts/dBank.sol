// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;

    constructor(Token _token) {
        token = _token;
    }

    function deposit() public payable {}

    function withdraw() public {}

    function borrow() public payable {}

    function payOff() public {}
}
