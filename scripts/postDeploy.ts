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

  const UserName = await hre.ethers.getContractFactory("UserName");
  const ColoredToken = await hre.ethers.getContractFactory("ColoredToken");
  const Cards = await hre.ethers.getContractFactory("Cards");

  const userName = UserName.attach(getAddress("UserName"));
  const coloredToken = ColoredToken.attach(getAddress("ColoredToken"));
  const cards = Cards.attach(getAddress("Cards"));

  const shopAddr = getAddress("Shop");

  console.log("Set shop on UserName");
  let tx = await userName.setShop(shopAddr, true);
  await tx.wait();

  console.log("Set shop on ColoredToken");
  tx = await coloredToken.setShop(shopAddr, true);
  await tx.wait();

  console.log("Set shop on Cards");
  tx = await cards.setShop(shopAddr, true);
  await tx.wait();
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
