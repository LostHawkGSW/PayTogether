pragma solidity ^0.4.21;

import "./BasicContract.sol";

/** @title Pay for anything, together! */
contract PayTogether {
	// Used to track whether or not this contract has ended
	bool public ended;
	// map addresses to funds to return
	mapping(address => uint) public pendingReturns;
	// list of users who are locked in
	address[] public lockedInUsers;
    mapping(address => bool) public lockedInUsersMap;
	// contract will payout if enough funds are available at this time
	// else it will add funds to return funds
	uint public autoEndInDays;
    uint public autoEndTime;
	// This is the contract we are attempt to pay together with
    address public contractToPay;
    // If this is a multi beneficiary, this will be the total cost per person
    uint public totalCost;
    uint public minUsers;
    uint public maxUsers;

    // the address for the admin (this will be the creator for now)
	address[] public admins;
    mapping(address => bool) public adminsMap;
	// In most cases this will be a single beneficiary
    // this is the address to tell the external contract to pay out/give to on success
	address[] public beneficiaries;

	bool public multiBeneficiary;

    event NewMemberJoined(
        address indexed _newMember,
        uint indexed _cost,
        uint indexed _newCost
    );

    event FundsReturnedDueToContractExpiration(
        uint indexed amount
    );

    event ExecutionSuccessful(
        uint indexed amount
    );

    modifier onlyBy(mapping(address => bool) _adminsMap)
    {
        require(
            _adminsMap[msg.sender] == true,
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
	  * @param _multiBeneficiary signify if the external contract should pay out/give to one or all
	  *        ex: hotel room goes to one person in charge -- flights go to each individual
	  * @param _totalCost the total cost for the contract (including gas)
	  * @param _minUsers the minimum locked in users for this contract to end successfully (this is a type of guarantee
	           to those joining the contract that the cost will be at most based on the minimum users.
	  * @param _maxUsers the maximum locked in users; once hit and all criteria are met contract should auto succeed
	  * @param _autoEndInDays when this contract will expire/attempt to complete automatically
	  */
	constructor (
        address _contract,
		bool _multiBeneficiary,
		uint _totalCost,
		uint _minUsers,
		uint _maxUsers,
		uint _autoEndInDays
	) public {
        // TODO -- remove this once we are comfortable with multi beneficiary testing
        require(
            !_multiBeneficiary,
            "Multi beneficiary payments are currently disabled."
        );
        contractToPay = _contract;
        admins.push(msg.sender);
        adminsMap[msg.sender] = true;
        multiBeneficiary = _multiBeneficiary;
        totalCost = _totalCost;
		beneficiaries = [msg.sender];
        autoEndTime = now + _autoEndInDays * 1 days;
        minUsers = _minUsers;
        maxUsers = _maxUsers;
	}

    function getPendingReturn(address member) public view returns(uint amount) {
        return pendingReturns[member];
    }

    function getAdmins() public view returns(address[] _admins) {
        return admins;
    }

    function isMember(address member) public view returns(bool _isMember) {
        return lockedInUsersMap[member] == true;
    }

	// function: join
	// should check that max users has not been hit
	// should check that expiry is not hit
	// should check that ended is not true
	// should check that amount is > current cost per person
	// should check if this is multi beneficiary -- if it is we need to add to beneficiary list
	// check if we need to return funds for any of the members
    // create an event that someone joined (and potentially that money is available for return)
    function join() public payable {
        doJoin(msg.sender, msg.value);
    }

    // implementation of join -- need to do it this way in order to test.
    function doJoin(address _sender, uint _amount) internal {
        require(
            !ended && now <= autoEndTime,
            "The contract has already ended."
        );

        require(
            lockedInUsers.length < maxUsers,
            "The contract is already full."
        );

        require(
            lockedInUsersMap[_sender] == false,
            "You are already locked into this contract."
        );

        uint newCost = nextCostPerPerson();
        require(
            _amount >= newCost,
            "The contract is already full."
        );

        uint currentCost = currentCostPerPerson();

        // Lock in this user
        lockedInUsers.push(_sender);
        lockedInUsersMap[_sender] = true;

        // Add to list of beneficiaries if this is a multibeneficiary contract
        if(multiBeneficiary) {
            beneficiaries.push(_sender);
        }

        // Return any excess the user sent
        if(msg.value > newCost) {
            pendingReturns[_sender] += _amount - newCost;
        }

        // Return any excess the other members sent
        if(newCost < currentCost) {
            uint amountToReturn = currentCost - newCost;
            for(uint i = 0; i < lockedInUsers.length; i++) {
                if(lockedInUsers[i] != _sender) {
                    pendingReturns[lockedInUsers[i]] += amountToReturn;
                }
            }
        }

        // Let everyone know that a new person has joined and if the cost has changed (and thus funds can be returned)
        //emit NewMemberJoined(_sender, currentCost, newCost);
    }

	// function: end (early/ttl)
    // should check min/max users
    // should check we have enough people locked in/enough money
    // should attempt to execute the contract
    // should trigger success/fail event
    // ** OPTIONAL FUTURE IMPLEMENTATION ** Add alarm clock usage so this gets trigger at expiration time
    function end() public onlyBy(adminsMap) {
        require(
            !ended,
            "The contract has already ended."
        );

        // Check if we can attempt to execute the function
        // which should only be done if we have not passed expiration autoEndTime
        // and that we have the correct number of users
        bool success = false;
        if(lockedInUsers.length >= minUsers &&
            lockedInUsers.length <= maxUsers &&
            now <= autoEndTime
          ) {
            if(multiBeneficiary) {
                success = BasicContract(contractToPay).execute(lockedInUsers);
            } else {
                success = BasicContract(contractToPay).execute(admins);
            }
        }

        uint currentCost = currentCostPerPerson();
        // If we were successful, let everyone know and end the contract
        // If we were not, and we are passed the end time, we should end the contract by returning all of the funds
        if(success) {
            emit ExecutionSuccessful(currentCost);
            ended = true;
        } else if(now > autoEndTime) {
            for(uint i = 0; i < lockedInUsers.length; i++) {
                if(lockedInUsers[i] != msg.sender) {
                    pendingReturns[lockedInUsers[i]] += currentCost;
                }
            }
            emit FundsReturnedDueToContractExpiration(currentCost);
            ended = true;
        }
    }

    // function: current cost per person
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (locked in users)))
    function currentCostPerPerson() public view returns (uint costPerPerson) {
        return calculateCost(lockedInUsers.length);
    }

    // function: next cost per person
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (locked in users + 1)))
    function nextCostPerPerson() public view returns (uint costPerPerson) {
        return calculateCost(lockedInUsers.length + 1);
    }

    // function: calculate cost
    // return flat cost pp if this is multi beneficiary
    // else this will return total min((cost/minUsers), (cost / (numUsers)))
    function calculateCost(uint numUsers) internal view returns (uint costPerPerson) {
        require(
            !ended && now <= autoEndTime,
            "The contract has already ended."
        );

        if(multiBeneficiary) {
            return totalCost;
        }
        uint minPerPersonCost = totalCost / minUsers;
        uint currentPerPersonCost = totalCost / numUsers;
        uint min = minPerPersonCost;
        if(currentPerPersonCost < min) {
            min = currentPerPersonCost;
        }
        return min;
    }

    // function: withdraw return funds
    function withdraw() public {
        doWithdraw(msg.sender);
    }

    function doWithdraw(address _sender) internal {
        uint amount = pendingReturns[_sender];
        pendingReturns[_sender] = 0;
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