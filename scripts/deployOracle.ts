/* eslint-disable no-process-exit */
import hre, { ethers } from "hardhat";
import { deployed } from "./utils/deployment";

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Oracle = await hre.ethers.getContractFactory("OracleETHAt1000");
  const oracle = await Oracle.deploy();
  await oracle.deployed();

  // save into deployed.json
  await deployed(
    "OracleETHAt1000",
    hre.network.name,
    oracle.address,
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
