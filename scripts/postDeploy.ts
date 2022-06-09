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
  console.log("Deploying contracts with the account:", deployer.address);

  const ColoredToken = await hre.ethers.getContractFactory("ColoredToken");
  const UserName = await hre.ethers.getContractFactory("UserName");
  const Cards = await hre.ethers.getContractFactory("Cards");

  const coloredToken = ColoredToken.attach(getAddress("ColoredToken"));
  const userName = UserName.attach(getAddress("UserName"));
  const cards = Cards.attach(getAddress("Cards"));

  const shopAddr = getAddress("Shop");

  console.log("Set shop on ColoredToken");
  let tx = await coloredToken.setShop(shopAddr);
  await tx.wait();

  console.log("Set shop on UserName");
  tx = await userName.setShop(shopAddr);
  await tx.wait();

  console.log("Set shop on Cards");
  tx = await cards.setShop(shopAddr);
  await tx.wait();
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
