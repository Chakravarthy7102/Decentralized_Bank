// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.6.0 <0.8.0;
//if you funk up check from here

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public minter;

    //event when the minter role is changed
    event MinterChanged(
        address indexed _fromerMinter,
        address indexed _newMinter
    );

    constructor() payable ERC20("Crypto Bank", "CRB") {
        minter = msg.sender;
    }

    //pass the minter role to the bank
    function passTheMinterRole(address bank) public returns (bool) {
        require(msg.sender == minter, "Only owner can pass the minter role");
        minter = bank;
        //every time you trigger a event you need to emit a event accoriding to the ERC 20 standards
        emit MinterChanged(msg.sender, bank);
        return true;
    }

    //function to mint or generate new tokens based on the intrest earned by the depositors into the
    //bank.
    function mint(address account, uint256 amount) public {
        require(
            account == minter,
            "To mint you need Minter Access! Which you dont have."
        );
        _mint(account, amount);
    }
}
