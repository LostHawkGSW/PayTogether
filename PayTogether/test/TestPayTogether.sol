pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayTogether.sol";
import "../contracts/BasicManyToOneContract.sol";

contract TestPayTogether {
    PayTogether public payTogetherContract;
    BasicManyToOneContract public basicContract;
    uint public totalCost;
    uint public minUsers;
    uint public maxUsers;
    uint public autoEndInDays;

    function beforeEach() public {
        totalCost = 1000;
        minUsers = 2;
        maxUsers = 4;
        autoEndInDays = 7;
        basicContract = new BasicManyToOneContract(totalCost);
        payTogetherContract = new PayTogether(
            address(basicContract),
            false,
            totalCost,
            minUsers,
            maxUsers,
            autoEndInDays
        );

    }

    function testWithdraw() public {
        Assert.equal(
            payTogetherContract.getPendingReturn(payTogetherContract.getAdmin()),
            0,
            "Theres should initially be nothing to return"
        );
    }
}