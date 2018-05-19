pragma solidity ^0.4.21;

// TODO: Eventually switch this to maybe return a new coin :shrug: -- coin can represent anything -- hotel? flight?
// For now we are just moving money.
contract BasicContract {
    bool public ended;
    uint public cost;

    constructor (uint _cost) public {
        cost = _cost;
    }

    function execute(address[] memory members) public payable returns (bool);
}