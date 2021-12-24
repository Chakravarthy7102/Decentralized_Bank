// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {
    Token private token;

    //mapping for keeping the track of addresses and there balance of eth

    mapping(address => uint256) public etherBalanceOf;
    mapping(address => uint256) public depositStart;
    mapping(address => bool) public isDeposited;

    //odd events
    event Deposit(address indexed _user, uint256 _amount, uint256 _timestamp);

    constructor(Token _token) {
        token = _token;
    }

    //deposits the ethers into the bank
    function deposit() public payable {
        //if the user has already deposited then revert the transaction
        require(
            isDeposited[msg.sender] == false,
            "Your Deposit is Already active"
        );
        require(
            msg.value >= 1e16,
            "Deposit must be of greater then or equal 0.01 ETH"
        );

        //take the deposited ammount and add it to the existing balance
        etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
        //adding up the timestamp value from the current block.
        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
        //setting the deposit status to true
        isDeposited[msg.sender] = true;
        //emitting the event
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {}

    function borrow() public payable {}

    function payOff() public {}
}
