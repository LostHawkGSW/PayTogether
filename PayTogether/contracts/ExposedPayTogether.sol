pragma solidity ^0.4.21;

import "./PayTogether.sol";

/** @title Pay for anything, together! */
contract ExposedPayTogether is PayTogether {
    constructor (address _contract,
        bool _multiBeneficiary,
        uint _totalCost,
        uint _minUsers,
        uint _maxUsers,
        uint _autoEndInDays) PayTogether(
            _contract,
            _multiBeneficiary,
            _totalCost,
            _minUsers,
            _maxUsers,
            _autoEndInDays
        ) public {}

    // implementation of join -- need to do it this way in order to test.
    function _doJoin(address _sender, uint _amount) public {
        return doJoin(_sender, _amount);
    }

    function _doWithdraw(address _sender) public {
        return doWithdraw(_sender);
    }
}