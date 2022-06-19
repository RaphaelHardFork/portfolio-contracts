# Contracts

## Security specification

**Owner's role:**

_Ownable's roles like `transferOwnership` are implicit_

- FungibleToken:
  - Can set oracle address
  - Can withdraw eth amount in the contract

**FungibleToken:**

- Token not capped, totalSupply potentially unlimited
- Oracle price rely on one oracle source (chainLink, Flux on Aurora network)

## To Do

=> security spec: what can do the owner

- test buy all booster
- fix name of the color
- erc20 donate for 1000 msg.value > ~0.5$ => multiple oracle price took the median
- shop is conttroller => see the contract controller => good to have multiple controller
- change shop on contracts => need ownable?
- set shop only owner
- _owner is time-locked multisig => centralise owner so (can be done after with transferOwnership)_

Integrate in the front

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
