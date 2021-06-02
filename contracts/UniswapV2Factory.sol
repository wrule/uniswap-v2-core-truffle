pragma solidity =0.5.16;

import './interfaces/IUniswapV2Factory.sol';
import './UniswapV2Pair.sol';

contract UniswapV2Factory is IUniswapV2Factory {
    // 费用 feeTo
    address public feeTo;
    // 费用 feeToSetter
    address public feeToSetter;

    // 存储币对数据库
    mapping(address => mapping(address => address)) public getPair;

    // 生成的币对地址列表
    address[] public allPairs;

    // 币对创建事件
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    // 构造函数，设置feeToSetter
    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    // 获取生成的币对个数
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    // 创建币对方法
    function createPair(address tokenA, address tokenB)
    external returns (address pair) {
        // 两个币地址不能相同
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');

        // 按币地址的创建顺序排序币地址（小地址在前，大地址在后）
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        
        // token0不能是0地址
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
        
        // 币对不能已经存在
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
        
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IUniswapV2Pair(pair).initialize(token0, token1);

        // 双向映射填充
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        
        // 添加到币对地址记录中
        allPairs.push(pair);
        
        // 触发币对添加事件
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    // feeToSetter可访问
    // 设置 feeTo
    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    // feeToSetter可访问
    // 设置 feeToSetter
    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
