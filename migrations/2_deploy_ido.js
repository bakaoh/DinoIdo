const IDO = artifacts.require("./IDO.sol");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(
    IDO,
    4, // 4 token for each BUSD
    accounts[0], // TODO: Replace with wallet to collect funds
    '0xe9e7cea3dedca5984780bafc599bd69add087d56', // BUSD bsc address
    '0xe9e7cea3dedca5984780bafc599bd69add087d56', // TODO: Replace me with Token address
    (new Date).getTime() + 60, // Opening time
    (new Date).getTime() + 60 * 60, // Closing time
  );
};
