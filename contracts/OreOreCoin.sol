pragma solidity ^0.4.18;

contract OreOreCoin {
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  mapping (address => uint256) public balanceOf;
  mapping (address => int8) public blackList;
  address public owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Blacklisted(address indexed  target);
  event DeleteFromBlacklist(address indexed  target);
  event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint256 value);
  event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint256 value);

  constructor(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
    balanceOf[msg.sender] = _supply;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    totalSupply = _supply;
    owner = msg.sender;
  }

  function blacklisting(address _addr) onlyOwner {
    blackList[_addr] = 1;
    emit Blacklisted(_addr);
  }

  function deletedFromBlacklist(address _addr) onlyOwner {
    blackList[_addr] = -1;
    emit DeleteFromBlacklist(_addr);
  }

  function transfer(address _to, uint256 _value) public {
    require(balanceOf[msg.sender] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    if (blackList[msg.sender] > 0){
      emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
    } else if (blackList[_to] > 0) {
      emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
    }else{
      balanceOf[msg.sender] -= _value;
      balanceOf[_to] += _value;

      emit Transfer(msg.sender, _to, _value);
    }
  }
}

