pragma solidity ^0.4.21;
import "../test/BaseTest.sol";

contract TestPayTogether is BaseTest {
    function testWithdraw() public {
        Assert.equal(
            payTogetherContract.getPendingReturn(payTogetherContract.getAdmins()[0]),
            0,
            "Theres should initially be nothing to return"
        );
        payTogetherContract._doJoin(accounts[1], 1 ether);
        Assert.equal(
            payTogetherContract.getPendingReturn(accounts[1]),
            .5 ether,
            "Theres should now be an excess .5 ether to return"
        );
        payTogetherContract._doWithdraw(accounts[1]);
        Assert.equal(
            address(accounts[1]).balance,
            .5 ether,
            "Should now have the withdrawn balance"
        );
    }
}