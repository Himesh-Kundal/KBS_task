// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract FundMe{

    address public Deployer = msg.sender;               // Initialising Withrawl and Deployer Address.
    address public Withrawl_Address = Deployer; 

    uint256 public MoneyRaised = 0;
    uint256 public MinimumETH = 2;                          // Min ether for Funding.

    address[] public funders;
    mapping(address=>uint256) public AddressToFunds;

    function fund() public payable {

        bool duplicate= false;
        for(uint256 i=0; i<funders.length;i++){         // Checking for Old Funder;
            if(funders[i]==msg.sender){
                duplicate = true;
                break;
            }
        }

        uint _MinETH = MinimumETH * 1e18;                   // Converting to ether.
        require(msg.value >= _MinETH ,"Send More");

        MoneyRaised += msg.value/1e18;

        if(duplicate)                                   // Adding Data
            AddressToFunds [msg.sender]+=msg.value;
        else{
            funders.push(msg.sender);                       
            AddressToFunds [msg.sender]=msg.value;
        }
    }

    function withraw() public {
        require(msg.sender==Deployer,"You are NOT the Deployer");
        for(uint256 i=0; i<funders.length;i++)
            AddressToFunds [funders[i]] = 0;            // mapping reset.
        
        funders = new address[](0);                     // Array reset. 
        MoneyRaised = 0;

        (bool Success,) = payable(Withrawl_Address).call{value: address(this).balance}("");
        require(Success,"Withrawl Failed");             // Withrawing.
    }

    function Change_Withrawl_Address(address NewAddress) public{
        require(msg.sender==Deployer,"You are NOT the Deployer");
        Withrawl_Address = NewAddress;
    }
}