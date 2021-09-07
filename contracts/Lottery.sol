// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    address public admin;
    address[] public participants;

    constructor() public {
        admin = msg.sender;
    }

    function entry() public payable {
        require(msg.value > 0.01 ether);

        participants.push(msg.sender);    
    }

    function pickWinner() public restrictedAdmin payable returns (address) {
        address payable winner = payable(participants[giveRandomIndex()]);
        winner.transfer(address(this).balance);
        participants = new address[](0);
        return winner;
    }

    modifier restrictedAdmin() {
        require(msg.sender == admin);
        _;
    }

    function giveRandomIndex() private view returns (uint) {
        return (uint(keccak256(abi.encodePacked(admin, participants, block.timestamp, block.difficulty))) % participants.length) - 1;
    }
    
 
}