const UniswapV2Factory = artifacts.require('UniswapV2Factory');

module.exports = (deployer) => {
  deployer.deploy(UniswapV2Factory, '0xd9B806613d73326643f51210249B1DE645751768');
};
