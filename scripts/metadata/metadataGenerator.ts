import { createCardMetadata } from "./utils/metadataLayer";

const metadataGenerator = async () => {
  for (let i = 0; i < 2; i++) {
    const editionName = i === 0 ? "normal" : "rare";
    for (let j = 0; j < 54; j++) {
      console.log(await createCardMetadata(j, editionName));
    }
  }
};

metadataGenerator();
