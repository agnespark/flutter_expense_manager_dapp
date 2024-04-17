const ExpenseManagerContract = artifacts.require("Migrations");

module.exports = function(deployer) {
    deployer.deploy(ExpenseManagerContract);
}