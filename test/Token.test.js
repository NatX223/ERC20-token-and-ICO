const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe ("CoinToken", function () {
    async function deployToken() {

        const MAX_CAP = 1000000000000000000000000n;

        const [Admin, Other, Next] = await ethers.getSigners();

        const CoinToken = await ethers.getContractFactory("coinToken");
        const cointoken = await CoinToken.deploy(MAX_CAP);

        return {cointoken, Admin, Other, Next};
    }

    describe("Token core functions", function () {
        it("should return the right decimals", async function () {
            const { cointoken } = await loadFixture(deployToken);

            expect(await cointoken.decimals()).to.equal(18);
        })

        it("should transfer properly", async function () {
            const { cointoken, Admin, Other } = await loadFixture(deployToken);
            const TRANSFER_AMOUNT = 1000;

            await cointoken.mint(Admin.address, TRANSFER_AMOUNT);
            await expect(cointoken.transfer(Other.address, TRANSFER_AMOUNT)).not.to.be.reverted;
        })

        it("should approve and spend properly", async function () {
            const { cointoken, Admin, Other, Next } = await loadFixture(deployToken);
            const TRANSFER_AMOUNT = 1000;

            await cointoken.mint(Admin.address, TRANSFER_AMOUNT);
            await cointoken.approve(Other.address, TRANSFER_AMOUNT);

            await expect(cointoken.connect(Other).transferFrom(Admin.address, Next.address, TRANSFER_AMOUNT)).not.to.be.reverted;
        })
        
        it("should burn properly", async function () {
            const { cointoken, Admin } = await loadFixture(deployToken);
            const BURN_AMOUNT = 1000;

            await cointoken.mint(Admin.address, BURN_AMOUNT);
            await expect(cointoken.burn(Admin.address, BURN_AMOUNT)).not.to.be.reverted;
        })

    })
})