/* eslint-disable no-process-exit */
import hre, { ethers } from "hardhat";
import { deployed } from "./utils/deployment";

const CONTRACT_NAME = "Cards";
const IPFS_HASH =
  "ipfs://bafybeidq3zoe2r2tjpo5rt43sljcybtst3zcvu7d7cbsuku2d7y7xywjni";

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Cards = await hre.ethers.getContractFactory(CONTRACT_NAME);
  const token = await Cards.deploy(IPFS_HASH);
  await token.deployed();

  // save into deployed.json
  await deployed(
    CONTRACT_NAME,
    hre.network.name,
    token.address,
    [IPFS_HASH],
    undefined
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
