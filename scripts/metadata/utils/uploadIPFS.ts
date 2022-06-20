/* eslint-disable no-process-exit */
import pinataSDK from "@pinata/sdk";

const PINATA_KEY = process.env.PINATA_KEY;
const PINATA_SECRET_KEY = process.env.PINATA_SECRET_KEY;

/**
 * Convert CIDv0 to CIDv1:
 * ipfs cid base32 Qm...
 */

export const uploadSvg = async (sourcePath: string, name: string) => {
  let pinata;
  if (PINATA_KEY !== undefined && PINATA_SECRET_KEY !== undefined) {
    pinata = pinataSDK(PINATA_KEY, PINATA_SECRET_KEY);
  } else {
    console.log("Cannot create Pinata client");
    process.exit(1);
  }

  console.log("Pinning to IPFS");
  try {
    const result = await pinata.pinFromFS(sourcePath, {
      pinataMetadata: {
        name,
      },
      pinataOptions: {
        cidVersion: 1,
      },
    });
    console.log(`Size of the file: ${result.PinSize / 1000}kb`);
    return result.IpfsHash;
  } catch (e) {
    console.log(e);
  }
};
