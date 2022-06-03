# Solidity TypeScript Template

![](https://img.shields.io/badge/Node.js-v16.15.0-blue)

## After cloning

```
yarn
forge update
```

Then add a `.env` file following the `.env.exemple` file

## Using

- Write smart contracts in `src`
- Write unit tests in **Solidity** using [Foundry](https://book.getfoundry.sh/forge/writing-tests.html) in `src/test`
- **OR**
- in **Javascript/Typescript** in `test`, you can use _typechain_ (once compilled) in TS

- Then deploy with scripts, you can use `deployed` function in your scripts ([see exemple](https://github.com/RaphaelHardFork/solidity-ts-template/blob/main/scripts/fungibleToken.ts#L16)) to save a track of your deployed contract in `deployed.json`

```
  npx hardhat run --network rinkeby scripts/yourScript.ts
```

## Verify contracts

Run the script `scripts/utils/verify.ts`, this should be used once the `deployed.json` is writen (after deployments).
