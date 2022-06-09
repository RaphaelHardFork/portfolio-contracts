import { readFile } from "fs/promises";
import { HashRegister } from "../uploadSvg";

/* eslint-disable camelcase */
type Attributes = {
  trait_type: string;
  value: string | number;
  max_value: undefined | string | number;
};

type OpenseaMetadata = {
  name: string;
  description: string;
  attributes: Attributes[];
  background_color: string;
  image: string;
};

const descriptionFactory = (symbol: string, value: string, edition: string) => {
  return `This card is not really useful, its value (${
    value + symbol
  }) as well. This is a collection of 9990 cards (excluding boosters), including 9720 cards (180x54) belonging to the "normal" edition and 270 cards (5x54) to the "rare" edition. \n\nThis card belong to the "${edition}" edition.`;
};

const valueToInfo = (value: number) => {
  value = (value % 13) + 1;
  switch (value) {
    case 1:
      return ["Ace", "A"];
    case 2:
      return ["Two", value.toString()];
    case 3:
      return ["Three", value.toString()];
    case 4:
      return ["Four", value.toString()];
    case 5:
      return ["Five", value.toString()];
    case 6:
      return ["Six", value.toString()];
    case 7:
      return ["Seven", value.toString()];
    case 8:
      return ["Eight", value.toString()];
    case 9:
      return ["Nine", value.toString()];
    case 10:
      return ["Ten", value.toString()];
    case 11:
      return ["Jack", "J"];
    case 12:
      return ["Queen", "Q"];
    case 13:
      return ["King", "K"];
    default:
      return ["Unknown", "?"];
  }
};

const valueToSymbol = (value: number) => {
  let symbol;
  let code;
  if (value < 13) {
    symbol = "Spades";
    code = "♠️";
  } else if (value < 26) {
    symbol = "Hearts";
    code = "♥️";
  } else if (value < 39) {
    symbol = "Clubs";
    code = "♣️";
  } else {
    symbol = "Diamonds";
    code = "♦️";
  }
  return [symbol, code];
};

export const createCardMetadata = async (value: number, edition: string) => {
  const parsedJson: HashRegister = JSON.parse(
    await readFile("assets_output/ipfsRegister.json", "utf-8")
  );
  const hashList = edition === "normal" ? parsedJson.normal : parsedJson.rare;
  const cardMetadata: OpenseaMetadata = {
    background_color: edition === "normal" ? "EEEEEE" : "DDDDDD",
  } as OpenseaMetadata;

  // JOKER
  if (value === 52 || value === 53) {
    cardMetadata.name = "JOKER";
    cardMetadata.description = descriptionFactory("KER", "JO", edition); // TO FILL
    cardMetadata.attributes = [
      { trait_type: "Rarity", value: edition, max_value: undefined },
      {
        trait_type: "Symbol",
        value: value === 52 ? "Black JOKER" : "Red JOKER",
        max_value: undefined,
      },
      { trait_type: "Value", value: "Joker", max_value: undefined },
      {
        trait_type: "Number of copie",
        value: edition === "normal" ? 180 : 5,
        max_value: 185,
      },
    ];
    cardMetadata.image = `ipfs://${hashList[value]}`;
  } else {
    const [number, code] = valueToInfo(value);
    const [symbol, sign] = valueToSymbol(value);

    cardMetadata.name = `${code}${sign} - ${number} of ${symbol}`;
    cardMetadata.description = descriptionFactory(sign, code, edition);
    cardMetadata.attributes = [
      { trait_type: "Rarity", value: edition, max_value: undefined },
      { trait_type: "Symbol", value: symbol, max_value: undefined },
      { trait_type: "Value", value: code, max_value: undefined },
      {
        trait_type: "Number of copie",
        value: edition === "normal" ? 180 : 5,
        max_value: 185,
      },
    ];
    cardMetadata.image = `ipfs://${hashList[value]}`;
  }

  return cardMetadata;
};
