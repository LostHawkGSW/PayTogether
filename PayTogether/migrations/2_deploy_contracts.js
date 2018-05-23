const PayTogether = artifacts.require("./PayTogether.sol")
const BasicManyToOneContract = artifacts.require("./BasicManyToOneContract.sol")

module.exports = function(deployer) {
    const totalCost = web3.toWei(1, 'ether');
    const minUsers = 2;
    const maxUsers = 4;
    const autoEndInDays = 7;
    const manyToMany = false;
    deployer.deploy(BasicManyToOneContract, totalCost).then(function(instance) {
        deployer.deploy(PayTogether, BasicManyToOneContract.address, manyToMany, totalCost, minUsers, maxUsers, autoEndInDays);
    });
};