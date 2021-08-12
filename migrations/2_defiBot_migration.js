const defibot = artifacts.require("DefiBot");

// contract addresses on mainnet
const DAI = "0x6b175474e89094c44da98b954eedeac495271d0f";
const UNISWAPRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
const AAVE = "0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9";

module.exports = function (deployer) {
  deployer.deploy(defibot, DAI, AAVE, UNISWAPRouter)
};