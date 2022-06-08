import { appendFile, mkdir, writeFile } from "fs/promises";
import { createInfoLayer } from "./utils/infoLayer";

const svgHeader = `<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="100%" height="100%" viewBox="0 0 1000 1400" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">`;

const cardWhiteBackground = `<!-- BACKGROUND -->
<path id="background" serif:id="background" d="M1000,50c0,-27.596 -22.404,-50 -50,-50l-900,0c-27.596,0 -50,22.404 -50,50l0,1300c0,27.596 22.404,50 50,50l900,0c27.596,0 50,-22.404 50,-50l0,-1300Z" style="fill:#fff;fill-opacity:1;"/>`;

const svgFooter = `<!-- END -->
</svg>`;

export const svgGenerator = async () => {
  try {
    await mkdir("assets_output");
  } catch (e) {
    console.log(e);
  }

  for (let i = 0; i < 2; i++) {
    const editionName = i === 0 ? "normal" : "rare";
    const colors =
      i === 0
        ? { black: undefined, red: undefined }
        : { black: "#57574F", red: "#F0C300" };
    await mkdir(`assets_output/${editionName}`);

    for (let j = 0; j < 54; j++) {
      // header
      await writeFile(`assets_output/${editionName}/${j}.svg`, svgHeader);
      await appendFile(
        `assets_output/${editionName}/${j}.svg`,
        cardWhiteBackground
      );

      // infos
      const infoLayer = createInfoLayer(j, colors.black, colors.red);
      await appendFile(`assets_output/${editionName}/${j}.svg`, infoLayer);

      // footer
      await appendFile(`assets_output/${editionName}/${j}.svg`, svgFooter);
    }
  }
};

svgGenerator();
