import { EthPool } from "../../typechain-types"
import { Signer } from "ethers";
// @ts-ignore
import { deployments, ethers } from "hardhat"
import { assert, expect } from "chai"

describe("Ethpool", function () {
  let ethPool: EthPool
  let accounts: Signer[];

  beforeEach(async function () {
    await deployments.fixture(["all"])
    ethPool = await ethers.getContract("EthPool")
    accounts = await ethers.getSigners();

  });

  it("Deposit", async function () {
    const address = accounts[1].toString()
    await ethPool.deposit({ from: address, value: 5000 })
    const amount = (await ethPool.checkAmountInPool())._hex
    expect(amount).not.equal(0)
  });
});
