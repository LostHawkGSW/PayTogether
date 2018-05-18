pragma solidity ^0.4.21;

/** @title Pay for anything, together! */
contract PayTogether {
	// Used to track whether or not this contract has ended
	bool public ended;
	// map addresses to funds
	mapping(address => uint) public deposits;
	// map addresses to funds to return
	mapping(address => uint) public return_funds;
	// list of users who are locked in
	address[] public locked_in_users;
	// contract will payout if enough funds are available at this time
	// else it will add funds to return funds
	uint public lockin_end_days;
    uint public lockin_end_time;
	// This is the contract we are attempt to pay together with
    address public contract_to_pay;
    uint public total_cost;
    uint public fixed_cost_per_person;

	address public admin;
	// In most cases this will be a single beneficiary
	address[] public beneficiaries;

	bool public multi_beneficiary;

	/**
	  * @dev constructor for contract
	  * @param _contract the contract this contract will be paying for
	  * @param _admin the address for the admin (this will be the creator for now)
	  * @param _beneficiary this is the address to tell the external contract to pay out/give to on success
	  * @param _multi_beneficiary signify if the external contract should pay out/give to one or all
	  *        ex: hotel room goes to one person in charge -- flights go to each individual
	  * @param _total_cost the total cost for the contract (including gas)
	  * @param _fixed_cost_per_person if this is a multi beneficiary contract; it is typically a cost per person
	  * @param _min_users the minimum locked in users for this contract to end successfully (this is a type of guarantee
	           to those joining the contract that the cost will be at most based on the minimum users.
	  * @param _max_users the maximum locked in users; once hit and all criteria are met contract should auto succeed
	  * @param _lockin_end_days when this contract will expire/attempt to complete automatically
	  */
	constructor (
        address _contract,
		address _admin,
		address _beneficiary,
		bool _multi_beneficiary,
		uint _total_cost,
		uint _fixed_cost_per_person,
		uint _min_users,
		uint _max_users,
		uint _lockin_end_days
	) public {
		contract_to_pay = _contract;
		admin = _admin;
		multi_beneficiary = _multi_beneficiary;
        if(multi_beneficiary) {
            fixed_cost_per_person = _fixed_cost_per_person;
        } else {
            total_cost = _total_cost;
        }
		beneficiaries = [_beneficiary];
		// if _lockin_time
		//    make sure funds were send that match for that many users
		lockin_end_time = now + _lockin_end_days * 1 days;
        min_users = _min_users;
        max_users = _max_users;
	}


	// function: join
	// should check that max users has not been hit
	// should check that expiry is not hit
	// should check that ended is not true
	// should check that amount is > current cost per person
	// should check if this is multi beneficiary -- if it is we need to add to beneficiary list
	// check if we need to return funds for any of the members
    // create an event that someone joined (and potentially that money is available for return)

	// function: current cost per person
	// return flat cost pp if this is multi beneficiary
	// else this will return total cost / (locked in users + 1)

	// function: end (early/ttl)
    // should check min/max users
    // should check we have enough people locked in/enough money
    // should attempt to execute the contract
    // should trigger success/fail event

	// function: withdraw return funds




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