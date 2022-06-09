/* eslint-disable dot-notation */
/* eslint-disable no-process-exit */
import { readFile } from "fs/promises";
import hre, { ethers } from "hardhat";
import { deployed, Root } from "./utils/deployment";

const CONTRACT_NAME = "Shop";

const main = async () => {
  let parsedJson: Root;
  try {
    parsedJson = JSON.parse(
      await readFile("./scripts/utils/deployed.json", "utf-8")
    );
  } catch (e) {
    console.log("Cannot read deployed.json or no deployed.json file");
    process.exit(1);
  }

  const { contracts } = parsedJson;

  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Shop = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const token = await Shop.deploy(
    contracts["ColoredToken"][hre.network.name].address,
    contracts["FungibleToken"][hre.network.name].address,
    contracts["UserName"][hre.network.name].address,
    contracts["Cards"][hre.network.name].address
  );
  await token.deployed();

  // save into deployed.json
  await deployed(
    CONTRACT_NAME,
    hre.network.name,
    token.address,
    [
      contracts["ColoredToken"][hre.network.name].address,
      contracts["FungibleToken"][hre.network.name].address,
      contracts["UserName"][hre.network.name].address,
      contracts["Cards"][hre.network.name].address,
    ],
    undefined
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
