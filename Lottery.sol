// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
   
contract Lottery {
    address public owner;
    address[] public players;

    constructor() {
        owner = msg.sender;
    }
 
    function enter() public payable {
        require(msg.value == 0.1 ether, "Must send exactly 0.1 ETH");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players joined yet");

        uint index = random() % players.length;
        address winner = players[index];

        payable(winner).transfer(address(this).balance);

        // Reset the lottery
        delete players;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
}
