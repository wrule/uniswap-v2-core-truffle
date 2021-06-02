const UniswapV2Factory = artifacts.require('UniswapV2Factory');

module.exports = (deployer) => {
  deployer.deploy(UniswapV2Factory, '');
};
