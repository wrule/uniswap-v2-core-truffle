const UniswapV2Factory = artifacts.require('UniswapV2Factory');

module.exports = (deployer) => {
  deployer.deploy(UniswapV2Factory, '0x6016C259F7c47052bfe88835c0d9817958AeeA26');
};
