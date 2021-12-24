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
    event Withdraw(
        address indexed _user,
        uint256 _userBalance,
        uint256 _depositTime,
        uint256 intrest
    );

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
        //beacuse the user gets to deposit money only once the timestamps wont overlap
        //adding because default value for uint in solidity is 0
        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
        //setting the deposit status to true
        isDeposited[msg.sender] = true;
        //emitting the event
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        //checks
        require(
            isDeposited[msg.sender] == true,
            "You have to deposit to withdraw"
        );
        uint256 userBalance = etherBalanceOf[msg.sender];

        //the total time the user is holding his coins in the bank is the below expression
        uint256 depositTime = block.timestamp - depositStart[msg.sender];
        //cal the intrest a user earned by the time of his/her withdrawing
        uint256 intrestPerSecond = 31668017 *
            (etherBalanceOf[msg.sender] / 1e16);
        uint256 intrest = intrestPerSecond * depositTime;

        //withdraw the ethers in the account completely and trasfer it to the depositor
        msg.sender.transfer(userBalance);
        etherBalanceOf[msg.sender] = 0;
        //minting the tokens that are earned as intrest by the user
        token.mint(msg.sender, intrest);

        //resetting the users data
        depositStart[msg.sender] = 0;
        isDeposited[msg.sender] = false;

        //emit the event
        emit Withdraw(msg.sender, userBalance, depositTime, intrest);
    }

    function borrow() public payable {}

    function payOff() public {}
}
