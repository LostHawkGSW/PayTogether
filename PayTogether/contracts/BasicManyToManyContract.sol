pragma solidity ^0.4.21;

import "./BasicContract.sol";

contract BasicManyToManyContract is BasicContract {
    constructor (uint _cost) BasicContract(_cost) public {}

    function execute(address[] memory members) public payable returns (bool) {
        require(
            !ended,
            "This contract has already ended."
        );
        require(
            msg.value >= (cost * members.length),
            "Insufficient funds."
        );
        // TODO: this is not clean/safe -- when this is changed to transfering ERC20/ERC721 should use a map to store
        // TODO: each persons owed amount and either transfer (and reduce owed amount) or emit that they can withdraw
        for(uint i = 0; i < members.length; i++) {
            members[i].transfer(cost);
        }
        ended = true;
        return true;
    }
}