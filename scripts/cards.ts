/* eslint-disable no-process-exit */
import hre, { ethers } from "hardhat";
import { deployed } from "./utils/deployment";

const CONTRACT_NAME = "Cards";

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Cards = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const token = await Cards.deploy(
    "ipfs://QmbPYzLk4hzRttP5qWpueUQzs8gnSHEdeV9fpNdsGChXUt/"
  );
  await token.deployed();

  // save into deployed.json
  await deployed(
    CONTRACT_NAME,
    hre.network.name,
    token.address,
    ["ipfs://QmbPYzLk4hzRttP5qWpueUQzs8gnSHEdeV9fpNdsGChXUt/"],
    undefined
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
