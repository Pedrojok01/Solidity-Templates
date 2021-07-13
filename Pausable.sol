pragma solidity 0.8.6;

contract PauseAContract {
    
    mapping (address => uint256) balances;
    address owner;
    bool private _paused;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier whenNotPaused(){
        require(!_paused);
        _;
    }
    
    modifier whenPaused(){
        require(_paused);
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _paused = false;
    }
    
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
    }

    function unPause() public onlyOwner whenPaused {
        _paused = false;
    }

    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    
    function deposit() public whenNotPaused payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdrawAll() public whenNotPaused {
        uint amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        _msgSender().transfer(amountToWithdraw);
    }
}