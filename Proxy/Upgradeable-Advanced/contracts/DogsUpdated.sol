pragma solidity 0.5.2;


//If ADD functionalities only: 
import "./Dogs.sol";

contract DogsUpdated is Dogs {

  constructor() public {
    initialize(msg.sender);
  }

  function initialize(address _owner) public {
    require(!_initialized);
    owner = _owner;
    _initialized = true;
  }
}

//If add and/or modify functionalities: 

/*
import "./Storage.sol";

contract DogsUpdated is Storage {

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  constructor() public {
    initialize(msg.sender);
  }

  function initialize(address _owner) public {
    require(!_initialized);
    owner = _owner;
    _initialized = true;
  }

  function getNumberOfDogs() public view returns(uint256) {
    return _uintStorage["Dogs"];
  }
  function setNumberOfDogs(uint256 toSet) public {
    _uintStorage["Dogs"] = toSet;
  }
  
}
*/