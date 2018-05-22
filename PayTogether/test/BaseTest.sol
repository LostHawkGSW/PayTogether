pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayTogether.sol";
import "../contracts/BasicManyToOneContract.sol";
import "../contracts/BasicManyToManyContract.sol";

contract BaseTest {
    PayTogether public payTogetherContract;
    BasicContract public basicContract;
    uint public totalCost = 1000;
    uint public minUsers = 2;
    uint public maxUsers = 4;
    uint public autoEndInDays = 7;
    bool public manyToMany = false;

    function beforeEach() public {
        if(manyToMany) {
            basicContract = new BasicManyToManyContract(totalCost);
        } else {
            basicContract = new BasicManyToOneContract(totalCost);
        }
        payTogetherContract = new PayTogether(
            address(basicContract),
            manyToMany,
            totalCost,
            minUsers,
            maxUsers,
            autoEndInDays
        );
    }
}