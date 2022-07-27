// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface Token {
    function claim(uint amount) external;
    function transfer(address to, uint256 amount) external;
}

contract tokenSale {

    // the start block for the ICO
    uint startblock;
    // the endblock of the ICO
    uint endblock;
    // the amount of tokens each Airdroper will get
    uint airdropAmount;
    // the waitlist/mapping for the Airdrop
    mapping (address => bool) airdropWaitlist;
    // mapping tracking Airdroped accounts
    mapping (address => bool) airdropedList;
    Token Coin;
    uint exchangeRate;

    constructor (uint _airdropAmount, address tokenAddress) {
        
        airdropAmount = _airdropAmount;
        startblock = block.timestamp;
        // setting the ICO time to approximately 2 months given there are 6380 blocks in one day
        endblock = startblock + (61 * 6380);
        Coin = Token(tokenAddress);
        exchangeRate = 100;
    }

    function buyCoin() payable public {
        require(block.timestamp < endblock, "Token sale has ended");
        require(msg.value > 0, "Invalid amount");
        uint amount = msg.value * exchangeRate;
        Coin.claim(amount);
    }

    function getListed() public {
        require(block.timestamp < endblock, "Token airdrop has ended");
        require(airdropedList[msg.sender] != true, "Airdrop can not be caimed more than once");
        require(airdropWaitlist[msg.sender] != true, "Airdrop can not be caimed more than once");
        airdropWaitlist[msg.sender] = true;
    }
    
    function getAirdrop() public {
        require(block.timestamp < endblock, "Token airdrop has ended");
        require(airdropedList[msg.sender] != true, "Airdrop can not be caimed more than once");
        Coin.transfer(msg.sender, airdropAmount);
        airdropedList[msg.sender] = true;
    }
}