// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './interfaces/IAAVE.sol';
import './interfaces/IUniswap.sol';
import './interfaces/IERC20.sol';


contract DefiBot{
    address DAI ;
    address AAVE;
    address UNISWAP;
    address public owner; 
    
    constructor (address dai, address aave, address uniswap){
        DAI = dai;
        AAVE = aave;
        UNISWAP = uniswap;
        owner = msg.sender;
    }
    

    modifier onlyOwner(){
        require(msg.sender == owner, 'cant call this contract');
        _;
    }

    function depositOnAave() public onlyOwner{
        // transferFrom msg.sender to contract 
        IERC20(DAI).transferFrom(msg.sender, address(this), IERC20(DAI).balanceOf(msg.sender));
        //allow aave spend your token
        IERC20(DAI).approve(AAVE, IERC20(DAI).balanceOf(address(this)) );
        //contract deposits on aave
        ILendingPool(AAVE).deposit(DAI, IERC20(DAI).balanceOf(address(this)), address(this), 0 );
    }
    
    function withdrawAndSwap() public onlyOwner {
        address aDAI = 0x028171bCA77440897B824Ca71D1c56caC55b68A3;//AAVE INTEREST BEARING TOKEN ADDRESS 
        //redeem from aave 
        ILendingPool(AAVE).withdraw(DAI, IERC20(aDAI).balanceOf(address(this)), address(this));
        
        address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address[] memory path = new address[](2);
        path[0] = DAI;
        path[1] = WETH; 
        
        IERC20(DAI).approve(UNISWAP, IERC20(DAI).balanceOf(address(this)) );
        //// swap for eth on uniswap and pay owner 
        IUniswapV2Router01(UNISWAP).swapExactTokensForETH(IERC20(DAI).balanceOf(address(this)), 0, path, owner, block.timestamp + 30 minutes);
        
    }
}