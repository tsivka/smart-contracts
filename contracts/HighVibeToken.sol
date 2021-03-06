pragma solidity ^0.4.13;

import "./Token.sol";

contract HighVibeToken is Token {

	bool public transfersEnabled = false;    // true if transfer/transferFrom are enabled, false if not

	// triggered when the total supply is increased
	event Issuance(uint256 _amount);
	// triggered when the total supply is decreased
	event Destruction(uint256 _amount);


  /* Initializes contract */
  constructor() public {
    standard = "HighVibe";
    name = "HighVibe";
    symbol = "HV"; // token symbol
    decimals = 18;
    cap = 8000000000 ether; // 8,000,000,000 tokens - should match maxTokenSupply in HighVibeCrowdsale.sol
  }

  function setCrowdsale(address _crowdsaleAddress) public onlyOwner {
    crowdsaleContractAddress = _crowdsaleAddress;
  }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }

    // verifies that the address is different than this contract address
    modifier notThis(address _address) {
        require(_address != address(this));
        _;
    }

    // allows execution only when transfers aren't disabled
    modifier transfersAllowed {
        require(transfersEnabled);
        _;
    }

   /**
        @dev disables/enables transfers
        can only be called by the contract owner

        @param _disable    true to disable transfers, false to enable them
    */
    function disableTransfers(bool _disable) public onlyOwner {
        transfersEnabled = !_disable;
    }

    // ERC20 standard method overrides with some extra functionality

    /**
        @dev send coins
        throws on any error rather then return a false flag to minimize user errors
        in addition to the standard checks, the function throws if transfers are disabled

        @param _to      target address
        @param _value   transfer amount

        @return true if the transfer was successful, false if it wasn't
    */
    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
        require(super.transfer(_to, _value));
        return true;
    }
  
    function transfers(address[] _recipients, uint256[] _values) public transfersAllowed onlyOwner returns (bool success) {
        require(_recipients.length == _values.length); // Check if input data is correct

        for (uint cnt = 0; cnt < _recipients.length; cnt++) {
            require(super.transfer(_recipients[cnt], _values[cnt]));
        }
        return true;
    }

    /**
        @dev an account/contract attempts to get the coins
        throws on any error rather then return a false flag to minimize user errors
        in addition to the standard checks, the function throws if transfers are disabled

        @param _from    source address
        @param _to      target address
        @param _value   transfer amount

        @return true if the transfer was successful, false if it wasn't
    */
    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
        require(super.transferFrom(_from, _to, _value));
        return true;
    }
}
