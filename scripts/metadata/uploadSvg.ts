import { writeFile } from "fs/promises";
import { uploadSvg } from "./utils/uploadIPFS";

export type HashRegister = {
  normal: string[];
  rare: string[];
};

const uploadFolder = async () => {
  const parsedJson: HashRegister = { normal: [], rare: [] };

  for (let i = 0; i < 54; i++) {
    const hash = await uploadSvg(
      `assets_output/normal/${i}.svg`,
      `Card n°${i + 1}`
    );
    parsedJson.normal.push(hash !== undefined ? hash : "Upload failed");
  }

  for (let i = 0; i < 54; i++) {
    const hash = await uploadSvg(
      `assets_output/rare/${i}.svg`,
      `Card n°${i + 1}`
    );
    parsedJson.rare.push(hash !== undefined ? hash : "Upload failed");
  }

  await writeFile(
    `assets_output/ipfsRegister.json`,
    JSON.stringify(parsedJson)
  );
};

uploadFolder();
