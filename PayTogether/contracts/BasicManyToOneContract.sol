pragma solidity ^0.4.21;

import "./BasicContract.sol";

contract BasicManyToOneContract is BasicContract {
    constructor (uint _cost) BasicContract(_cost) public {}

    function execute(address[] memory members) public payable returns (bool) {
        require(
            !ended,
            "This contract has already ended."
        );
        require(
            members.length == 1,
            "Many to one contracts should only have one member to return to."
        );
        require(
            msg.value >= cost,
            "Insufficient funds."
        );
        members[0].transfer(cost);
        ended = true;
        return true;
    }
}