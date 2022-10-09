// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract Account is ERC721{
    address owner;
    uint96 tokenId = 0;
    struct User{
        string name;
        string hometown;
        string country;
        uint96 tokenId;
    
    }
    mapping(address=>User)accounts;
    mapping(address=>bool)whitelistStates;
    constructor()ERC721("Account","ACC"){
        owner = msg.sender;
    }
    function createAccount(string calldata username)external {
        require(accounts[msg.sender].tokenId==0,"Account already minted");
        _mint(msg.sender,tokenId);
        accounts[msg.sender] = User(username,"","",tokenId);
        whitelistStates[msg.sender]= false;
    }

    function whitelist(address user)external{
        
        require(msg.sender == owner,"not owner");
        require(whitelistStates[user]==false,"already wl");
        require(accounts[user].tokenId==0,"Account already minted");
        whitelistStates[user]= true;

    }

}