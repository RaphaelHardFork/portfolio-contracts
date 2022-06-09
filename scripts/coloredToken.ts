/* eslint-disable no-process-exit */
import hre, { ethers } from "hardhat";
import { deployed } from "./utils/deployment";

const CONTRACT_NAME = "ColoredToken";

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ColoredToken = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const token = await ColoredToken.deploy();
  await token.deployed();

  // save into deployed.json
  await deployed(
    CONTRACT_NAME,
    hre.network.name,
    token.address,
    undefined,
    undefined
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
