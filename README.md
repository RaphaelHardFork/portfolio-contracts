# Contracts

## Security specification

### Trust model:

_Ownable's roles like `transferOwnership` are implicit_

- **FungibleToken:**
  - Can set oracle address
  - Can withdraw eth amount in the contract
- **Shopable contracts (ColoredToken):**
  - Owner can set/remove an address as "shop" (controller)
- **ColoredToken:**
  - Owner can withdraw eth amount in the contract

### FungibleToken:

- Token not capped, totalSupply potentially unlimited
- Oracle price rely on one oracle source (chainLink, Flux on Aurora network)

### ColoredToken:

- burning a token cost 0.00005 ETH, this cost can be avoided by transfering to a random address that not own a token.

---

## To Do

- test buy all booster / check token URI (booster) / check distribution 180/5
- test shop/ change shop / several shop

Integrate in the front

- _owner is time-locked multisig => centralise owner so (can be done after with transferOwnership)_

---

- shop UUPS with new contracts (v1,v2,...) => upgrades integration in template
- signature => nft for 0 ethers != with some => two image => ERC721 is good, cannot transfer to force the meta-tx => mint and transfer only if 0 eth

## Standard to implement

- diamond-like pattern
- clones proxy
- royalties with payment splitter => find an exemple of collections/theme

## Oracles

### Chainlink

**Rinkeby (ETH/USD|8):** 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e

**Polygon (MATIC/USD|8):** 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0

### Flux

**Aurora (ETH/USD):** 0xA8Ac2Fa1D239c7d96046967ED21503D1F1fB2354
