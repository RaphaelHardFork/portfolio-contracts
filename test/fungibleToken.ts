/* eslint-disable no-unused-vars */
import { AuthorisedToken } from "../typechain";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("FungibleToken", () => {
  let user1: any;
  let user2: any;

  beforeEach(async () => {
    [user1, user2] = await ethers.getSigners();
  });

  it("Should deploy the contract", async () => {
    const FungibleToken = await ethers.getContractFactory("FungibleToken");
    const ft = await FungibleToken.deploy();
    await ft.deployed();

    const Shop = await ethers.getContractFactory("Shop");
    const shop = await Shop.deploy(user1.address, ft.address);
    await shop.deployed();
  });
});
