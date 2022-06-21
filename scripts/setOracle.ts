/* eslint-disable dot-notation */
/* eslint-disable no-process-exit */
import { readFile } from "fs/promises";
import hre, { ethers } from "hardhat";
import { Root } from "./utils/deployment";

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

  const getAddress = (name: string) => {
    return parsedJson.contracts[name][hre.network.name].address;
  };

  const [deployer] = await ethers.getSigners();
  console.log("Interacting contracts with the account:", deployer.address);

  const FungibleToken = await hre.ethers.getContractFactory("FungibleToken");
  const fungibleToken = FungibleToken.attach(getAddress("FungibleToken"));

  const oracleAddr = "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e";

  console.log("Set oracle on FungibleToken");
  const tx = await fungibleToken.setOracle(oracleAddr);
  await tx.wait();
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
