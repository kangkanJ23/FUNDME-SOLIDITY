pragma solidity ^0.6.0;
import "./fundMe.sol";

contract fundMeFactory {
    address[] public deployedFundraisers;
    uint public totalDeployedFundraisers;
    address private owner;
    
    function createNewFundMe(string memory _firstName, string memory _lastName, string memory _description, uint _amountNeeded) public {
        fundMe newFundMe = new fundMe(_firstName, _lastName, _description, _amountNeeded);
        deployedFundraisers.push(address(newFundMe));
        totalDeployedFundraisers++;
    }
    
    function getDeployedFundraisers() public view returns(address[] memory) {
        return deployedFundraisers;
    }
}

