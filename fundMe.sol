pragma solidity ^0.6.0;

contract fundMe {
    
    struct donation {
        address donor;
        uint donationAmount;
    }
    
    address public owner;
    string public description;
    string public firstName;
    string public lastName;
    uint public amountNeeded;
    
    
    mapping(address => uint) public donorAmount;
    uint public donors;
    uint public amountRaisedTillNow;
    donation[] public donations;
    
    bool public ongoing;
    bool public withdrawn;
    
    modifier isRestricted() {
        require(msg.sender == owner,'only owner can perform this action');
        _;
    }
    
    modifier isLive() {
        require(ongoing,"this fundraiser has ended");
        _;
    }
    
    event fundraiserCreated(address indexed _from, address indexed _contract, string _description);
    event fundsDonated(address indexed _from, address indexed _contract, uint _value);
    event fundsWithdrawAndFundraiserEnded(address indexed _from, address indexed _contract, uint _value); 
    
    constructor(string memory _firstName, string memory _lastName, string memory _description, uint _amountNeeded) public {
        firstName = _firstName;
        lastName = _lastName;
        description = _description;
        amountNeeded = _amountNeeded;
        owner = tx.origin;
        ongoing = true;
        emit fundraiserCreated(tx.origin, address(this), _description);
    }
    
    function donate() public isLive payable {
        if(donorAmount[msg.sender] == 0) {
            donors++;
        }
        donorAmount[msg.sender]+= msg.value;
        amountRaisedTillNow += msg.value;
        donations.push(donation(msg.sender,msg.value));
        emit fundsDonated(msg.sender, address(this), msg.value);
        if(amountRaisedTillNow >= amountNeeded) {
            ongoing = false;
        }
    }
    
    function withdrawAndEnd() public isRestricted {
        require(!withdrawn);
        ongoing = false;
        payable(owner).transfer(address(this).balance);
        withdrawn = true;
        emit fundsWithdrawAndFundraiserEnded(msg.sender, address(this), address(this).balance);
    }
}