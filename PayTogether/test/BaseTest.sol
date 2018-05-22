pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayTogether.sol";
import "../contracts/ExposedPayTogether.sol";
import "../contracts/BasicManyToOneContract.sol";
import "../contracts/BasicManyToManyContract.sol";

contract BaseTest {
    ExposedPayTogether public payTogetherContract;
    BasicContract public basicContract;
    uint public totalCost = 1 ether;
    uint public minUsers = 2;
    uint public maxUsers = 4;
    uint public autoEndInDays = 7;
    bool public manyToMany = false;
    address[] public accounts = new address[](0);

    function beforeEach() public {
        if(manyToMany) {
            basicContract = new BasicManyToManyContract(totalCost);
        } else {
            basicContract = new BasicManyToOneContract(totalCost);
        }
        payTogetherContract = new ExposedPayTogether(
            address(basicContract),
            manyToMany,
            totalCost,
            minUsers,
            maxUsers,
            autoEndInDays
        );
    }
}