import { mkdir, writeFile } from "fs/promises";
import { createCardMetadata } from "./utils/metadataLayer";

const metadataGenerator = async () => {
  try {
    await mkdir("assets_output/metadata");
  } catch (e) {
    console.log(e);
  }

  for (let i = 0; i < 2; i++) {
    const editionName = i === 0 ? "normal" : "rare";
    for (let j = 0; j < 54; j++) {
      const metadata = await createCardMetadata(j, editionName);
      await writeFile(
        `assets_output/metadata/${j + 54 * i}.json`,
        JSON.stringify(metadata)
      );
    }
  }
};

metadataGenerator();
