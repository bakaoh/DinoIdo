const Web3 = require("web3");
const ido = require("../build/contracts/IDO.json");

async function run() {
    let web3 = new Web3("HTTP://127.0.0.1:7545");
    let idoContract = new web3.eth.Contract(ido.abi, "0x431e3823f81f9fD93776B5eae823283752131e4a");
    let getUserContribution = await idoContract.methods.getUserContribution("0x431e3823f81f9fD93776B5eae823283752131e4a").call();
    console.log(getUserContribution);

    let buyTokens = await idoContract.methods.buyTokens(new web3.utils.BN('250000000000000000000')).call();
    console.log(buyTokens);
}

run();