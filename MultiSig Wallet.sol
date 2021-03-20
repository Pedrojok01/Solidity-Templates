// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
pragma abicoder v2;


contract MultisigWallet {
    
    
/* *** Storage ***
===================*/

    mapping(address => mapping(uint => bool)) approvals;
    address[] public owners;
    Transaction[] transactions;
    uint requiredApprovals;
    uint public balance = 0;
    
    struct Transaction {
        uint amount;
        address payable receiver;
        uint approvals;
        bool executed;
        uint txId;
    }
    
    
/* *** Events ***
==================*/

    event depositDone(uint amount, address indexed depositedTo);
    event TransactionRequestCreated(uint _txId, uint _amount, address _creator, address _receiver);
    event ApprovalReceived(uint _txId, uint _approvals, address _approver);
    event TransactionApproved(uint _txId);
    event OwnerRemoval(address indexed _owner);
    event OwnerAddition(address indexed _newOwner);

    
/* *** Constructor ***
=======================*/

    constructor(address[] memory _owners, uint _requiredApprovals) {
        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }
    
    
/* *** Modifiers ***
=====================*/

    modifier onlyOwners(){
        bool owner = false;
        for (uint i=0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                owner = true;
            }
        }
        require(owner == true, "Only the owner can do this!");
        _;
    }

    
/* *** Functions ***
=====================*/

    function replaceOwner(address _owner, address _newOwner) public onlyOwners {
        for (uint i=0; i<owners.length; i++)
            if (owners[i] == _owner) {
                owners[i] = _newOwner;
                break;
            }
        emit OwnerRemoval(_owner);
        emit OwnerAddition(_newOwner);
    }
    
    function deposit() public payable returns (uint) {
        balance += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance;
    }
    
    function createTransaction(uint _amount, address payable _receiver) public onlyOwners {
        require(balance >= _amount, "Balance insufficient");
        require(msg.sender != _receiver, "Can't send to yourself");
        
        emit TransactionRequestCreated(transactions.length, _amount, msg.sender, _receiver);
        transactions.push(Transaction(_amount, _receiver, 0, false, transactions.length));
        balance -= _amount;
    }
    
    function approve(uint _txId) public onlyOwners {
        require(approvals[msg.sender][_txId] == false, "Transaction already confirmed!");
        require(transactions[_txId].executed == false, "Transaction already executed!");
        
        approvals[msg.sender][_txId] = true;
        transactions[_txId].approvals++;
        emit ApprovalReceived(_txId, transactions[_txId].approvals, msg.sender);
        
        if (transactions[_txId].approvals >= requiredApprovals) {
            transactions[_txId].executed = true;
            transactions[_txId].receiver.transfer(transactions[_txId].amount);
            emit TransactionApproved(_txId);
        }
    }
    
    function getTransaction() public view returns (Transaction[] memory){
        return transactions;
    }
}