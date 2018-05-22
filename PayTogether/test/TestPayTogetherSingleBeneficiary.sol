pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PayTogether.sol";
import "../contracts/BasicManyToOneContract.sol";

contract TestPayTogetherSingleBeneficiary is BaseTest {
    function testJoin() {
        Assert.isFalse(
            payTogetherContract.isMember(accounts[1]),
            "Should not be a member before joining"
        );
        payTogetherContract._doJoin(accounts[1], .5 ether);
        Assert.isTrue(
            payTogetherContract.isMember(accounts[1]),
            "Should be a member after joining"
        );
        // TODO -- test for event emit
    }

    function testEnd() {
        Assert.isFalse(payTogetherContract.ended);
        Assert.isFalse(
            payTogetherContract.end(),
            "Should not be able to end the with only one member when min is 2"
        );
        payTogetherContract._doJoin(accounts[1], .5 ether);
        Assert.isTrue(
            payTogetherContract.end(),
            "Should be able to end with 2 members"
        );
        Assert.isTrue(payTogetherContract.ended);
        // TODO -- test for event emit
    }

    function testCurrentCostPerPerson() {
        Assert.equal(
            payTogetherContract.currentCostPerPerson(),
            totalCost,
            "Current cost should be same as totalCost"
        );
        payTogetherContract._doJoin(accounts[1], .5 ether);
        Assert.equal(
            payTogetherContract.currentCostPerPerson(),
            totalCost / 2,
            "Current cost should be half of totalCost"
        );
    }

    function testNextCostPerPerson() {
        Assert.equal(
            payTogetherContract.nextCostPerPerson(),
            totalCost / 2,
            "Next cost should be half of totalCost"
        );
        payTogetherContract._doJoin(accounts[1], .5 ether);
        Assert.equal(
            payTogetherContract.nextCostPerPerson(),
            totalCost / 3,
            "Next cost should be a third of totalCost"
        );
    }
}