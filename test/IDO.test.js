const { BN } = require('@openzeppelin/test-helpers');
const IDO = artifacts.require("IDO");
const ERC20 = artifacts.require("ERC20");

const sleep = (ms) => new Promise(res => setTimeout(res, ms));

contract("IDO", function([creator]) {
    before(async function() {
        this.busd = await ERC20.new("DummyBUSD", "BUSD");
        this.dino = await ERC20.new("DummyDINO", "DINO");
        this.ido = await IDO.new(
            4, // 4 DINO for each BUSD
            creator,
            this.busd.address,
            this.dino.address,
            (new Date).getTime(), // Opening time
            (new Date).getTime() + 60 * 60, // Closing time);
        );
    });

    it("buyTokens", async function() {
        await this.ido.addToWhitelist(creator);
        let buyTokens = await this.ido.buyTokens(new BN('250000000000000000000'));
        console.log(buyTokens);
    });

    it("getUserContribution", async function() {
        console.log(creator);
        let buyTokens = await this.ido.getUserContribution(creator);
        console.log(buyTokens.toString());
    });
});