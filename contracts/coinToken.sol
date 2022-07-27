// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract coinToken is ERC20 {

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    // the total amount of tokens in circulation
    uint public _totalSupply;
    // the max amount of tokens that can be minted or in circulation
    uint public _coinCap;

    string public _name;
    string public _symbol;

    uint8 _decimals;

    constructor(uint cap) ERC20("Coin", "CN") {
        _coinCap = cap * (10 ** 18);
        _decimals = 18;
    }

    // function to mint the token
    function mint(address account, uint amount) public {
        require(_totalSupply < _coinCap, "Total supply cap has been reached");
        require(amount > 0, "amount must be more than zero");

        _mint(account, amount);
    }

    // function that returns the token decimal denomination
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    // function to transfer token
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(to != address(0), "receiver can not be zero address");
        require(amount > 0, "amount can not be less than zero");
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    // function to approve a address to spend your tokens
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(spender != address(0), "address is not valid");
        require(amount > 0, "amount must be more than zero");
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    // function to spend another address tokens
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        uint balance = balanceOf(from);
        uint _allowance = allowance(from, msg.sender);

        require(from != address(0), "address is not valid");
        require(to != address(0), "address is not valid");
        require(balance >= amount, "address is not valid");
        require(_allowance >= amount, "address is not valid");

        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    // function to increase allowance
    function increaseAllowance(address spender, uint256 addedValue) public override virtual returns (bool) {
        require(spender != address(0), "address is not valid");
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    //function to burn tokens
    function burn (address account, uint amount) public {
        _burn(account, amount);
    }

    // function to buy token
    function claim (uint amount) payable external{
        mint(msg.sender, amount);
    }
}