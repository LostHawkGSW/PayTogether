pragma solidity ^0.4.21;

/** @title Pay for anything, together! */
contract PayTogether {
	// Used to track whether or not this contract has ended
	bool public ended;
	// map addresses to funds
	mapping(address => uint deposit) public deposits;
	// map addresses to funds to return
	mapping(address => uint return_fund) public return_funds;
	// list of users who are locked in
	address[] public locked_in_users
	// contract will payout if enough funds are available at this time
	// else it will add funds to return funds
	uint public lockin_end_days;
	// This is the contract we are attempt to pay together with
	contract public contract_to_pay;

	address public admin;
	// In most cases this will be a single beneficiary
	address[] public beneficiaries;

	bool public multi_beneficiary;

	function SplitIt(
		contract _contract,
		uint _contract_gas,
		address _admin,
		address _beneficiary,
		bool _multi_beneficiary,
		uint _total_cost,
		uint _flat_cost_per_person,
		uint _min_users,
		uint _max_users,
		uint _num_guaranteed_users,
		uint _lockin_end_days
	) public {
		contract_to_pay = _contract;
		// TODO must store this gas for later use per person joining or build into total 
		contract_gas = _contract_gas;
		admin = _admin;
		multi_beneficiary = _multi_beneficiary
		beneficiaries = [_beneficiary];
		// if _lockin_time
		//    make sure funds were send that match for that many users
		lockin_end_time = now + _lockin_end_days * 1 days;
	}


	// function: join
	// should check that max users has not been hit
	// should check that expiry is not hit
	// should check that ended is not true
	// should check that amount is > current cost per person
	// should check if this is multi beneficiary -- if it is we need to add to beneficiary list

	// function: request to leave
	// if multi beneficiary allow
	// else must check with others to cover

	// function: cover costs for someone else to stay/join

	// function: cover cost for someone leaving (guarntee to others the num of people wont change)

	// function: cancel request to leave

	// function: reject request to leave

	// function: accept leave request

	// function: end early

	// function: withdraw return funds

	// function: change admin
	// should check if current admin is setting this
	// should check if the new admin is already locked in

	// function: current cost per person
	// return flat cost pp if this is multi beneficiary
	// else this will return total cost / (locked in users + 1)
}