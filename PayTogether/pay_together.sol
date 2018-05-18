pragma solidity ^0.4.21;

import "math.sol"

/** @title Pay for anything, together! */
contract PayTogether {
	// Used to track whether or not this contract has ended
	bool public ended;
	// map addresses to funds
	mapping(address => uint) public deposits;
	// map addresses to funds to return
	mapping(address => uint) public pendingReturns;
	// list of users who are locked in
	address[] public lockedInUsers;
	// contract will payout if enough funds are available at this time
	// else it will add funds to return funds
	uint public autoEndInDays;
    uint public autoEndTime;
	// This is the contract we are attempt to pay together with
    address public contractToPay;
    uint public totalCost;
    uint public fixedCostPerPerson;
    uint public minUsers;
    uint public maxUsers;

	address public admin;
	// In most cases this will be a single beneficiary
	address[] public beneficiaries;

	bool public multiBeneficiary;

    modifier onlyBy(address _account)
    {
        require(
            msg.sender == _account,
            "Sender not authorized."
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

	/**
	  * @dev constructor for contract
	  * @param _contract the contract this contract will be paying for
	  * @param _admin the address for the admin (this will be the creator for now)
	  * @param _beneficiary this is the address to tell the external contract to pay out/give to on success
	  * @param _multi_beneficiary signify if the external contract should pay out/give to one or all
	  *        ex: hotel room goes to one person in charge -- flights go to each individual
	  * @param _totalCost the total cost for the contract (including gas)
	  * @param _fixedCostPerPerson if this is a multi beneficiary contract; it is typically a cost per person
	  * @param _min_users the minimum locked in users for this contract to end successfully (this is a type of guarantee
	           to those joining the contract that the cost will be at most based on the minimum users.
	  * @param _max_users the maximum locked in users; once hit and all criteria are met contract should auto succeed
	  * @param _autoEndInDays when this contract will expire/attempt to complete automatically
	  */
	constructor (
        address _contract,
		address _admin,
		address _beneficiary,
		bool _multiBeneficiary,
		uint _totalCost,
		uint _fixedCostPerPerson,
		uint _minUsers,
		uint _maxUsers,
		uint _autoEndInDays
	) public {
        contractToPay = _contract;
		admin = _admin;
        multiBeneficiary = _multiBeneficiary;
        if(multiBeneficiary) {
            fixedCostPerPerson = _fixedCostPerPerson;
        } else {
            totalCost = _totalCost;
        }
		beneficiaries = [_beneficiary];
        autoEndTime = now + _autoEndInDays * 1 days;
        minUsers = _minUsers;
        maxUsers = _maxUsers;
	}


	// function: join
	// should check that max users has not been hit
	// should check that expiry is not hit
	// should check that ended is not true
	// should check that amount is > current cost per person
	// should check if this is multi beneficiary -- if it is we need to add to beneficiary list
	// check if we need to return funds for any of the members
    // create an event that someone joined (and potentially that money is available for return)

	// function: end (early/ttl)
    // should check min/max users
    // should check we have enough people locked in/enough money
    // should attempt to execute the contract
    // should trigger success/fail event

    // function: current cost per person
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (locked in users)))
    function currentCostPerPerson() public returns (uint costPerPerson) {
        return calculateCost(lockedInUsers.length);
    }

    // function: next cost per person
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (locked in users + 1)))
    function nextCostPerPerson() public returns (uint costPerPerson) {
        return calculateCost(lockedInUsers.length + 1);
    }

    // function: calculate cost
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (numUsers)))
    function calculateCost(uint numUsers) private returns (uint costPerPerson) {
        if(multiBeneficiary) {
            return fixedCostPerPerson;
        }
        uint minPerPersonCost = totalCost / minUsers;
        uint currentPerPersonCost = totalCost / numUsers;
        return Math.min(minPerPersonCost, currentPerPersonCost);
    }

    // function: withdraw return funds
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        pendingReturns[msg.sender] = 0;
        msg.sender.transfer(amount);
    }




	// **The following functions are not needed for basic functionality**

	// (**Optional**) function: request to leave
	// if multi beneficiary allow
	// else must check with others to cover

	// (**Optional**) function: cover costs for someone else to stay/join

	// (**Optional**) function: cover cost for someone leaving (guarntee to others the num of people wont change)

	// (**Optional**) function: cancel request to leave

	// (**Optional**) function: reject request to leave

	// (**Optional**) function: accept leave request

	// (**Optional**) function: change admin
	// should check if current admin is setting this
	// should check if the new admin is already locked in
}