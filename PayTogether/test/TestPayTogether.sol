pragma solidity ^0.4.21;
import "../test/BaseTest.sol";

contract TestPayTogether is BaseTest {
    function testWithdraw() public {
        Assert.equal(
            payTogetherContract.getPendingReturn(payTogetherContract.getAdmins()[0]),
            0,
            "Theres should initially be nothing to return"
        );
    }
}