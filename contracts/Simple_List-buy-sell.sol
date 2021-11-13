// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HMNFTMarket is ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private listedNFTsCount;
    
    constructor() {}
    address public NFTContractAddress = 0x0000000000000000000000000000000000000000;
    
    struct MarketSellListings {
        uint NFTTokenId;
        uint sellingPrice;
        address payable sellerAddress;
        bool isActiveForSelling;
    }

   mapping(uint256=> MarketSellListings) public MarketListings;
   
                        //block.timestamp
   event bought(uint256 datetime, uint256 indexed _tokenId, uint256 _price, address indexed nftOwner, address indexed nftSeller);
   event transfered(uint256 datetime, uint256 indexed _tokenId, address indexed fromOwner, address indexed toNewOwner);
   event settedForSale(uint256 datetime, uint256 indexed _tokenId, uint256 _price, address indexed nftOwner);
   event disabledSelling(uint256 datetime, uint256 indexed _tokenId, address indexed nftOwner);
   
   function createListing(uint256 _price, uint256 _tokenId) public nonReentrant {
       require(_price >= 0, "Must be positive price");
       require(IERC721(NFTContractAddress).ownerOf(_tokenId) == msg.sender);
       //require(IERC721(NFTContractAddress).totalSupply() > _tokenId);
       //require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
       MarketListings[_tokenId] = MarketSellListings(
           _tokenId,
           _price,
           payable(msg.sender),
           true
           );
       emit settedForSale(block.timestamp, _tokenId, _price, msg.sender);
   }
   
    function buy(uint256 _tokenId) public payable nonReentrant{
        require(MarketListings[_tokenId].isActiveForSelling == true, 'Owner is not selling the NFT');
        require(MarketListings[_tokenId].sellingPrice >= msg.value, 'Selling price not met');
        require(IERC721(NFTContractAddress).ownerOf(_tokenId) == MarketListings[_tokenId].sellerAddress, 'Seller no longer own the NFT');
        
        MarketListings[_tokenId].sellerAddress.transfer(msg.value);
        IERC721(NFTContractAddress).transferFrom(MarketListings[_tokenId].sellerAddress, msg.sender, _tokenId);
        
       
        emit bought(block.timestamp,_tokenId, msg.value, msg.sender, MarketListings[_tokenId].sellerAddress);
        emit disabledSelling(block.timestamp, _tokenId, MarketListings[_tokenId].sellerAddress);
        MarketListings[_tokenId].isActiveForSelling = false;
        MarketListings[_tokenId].sellerAddress = payable(msg.sender);
    }
    
    function cancellListing(uint256 _tokenId) public nonReentrant {
        require(MarketListings[_tokenId].isActiveForSelling == true, 'Owner is not selling the NFT');
        require(IERC721(NFTContractAddress).ownerOf(_tokenId) == MarketListings[_tokenId].sellerAddress, 'Seller no longer own the NFT');
        require(IERC721(NFTContractAddress).ownerOf(_tokenId) == msg.sender, 'Only owner should cancel the listing');
        MarketListings[_tokenId].isActiveForSelling = false;
        emit disabledSelling(block.timestamp, _tokenId, payable(msg.sender));
    }
    
    function transferNFT(uint256 _tokenId, address _to) public nonReentrant {
        require(IERC721(NFTContractAddress).ownerOf(_tokenId) == msg.sender, 'Only owner should transfer');
        MarketListings[_tokenId].isActiveForSelling = false;
        IERC721(NFTContractAddress).transferFrom(msg.sender, _to , _tokenId);
        emit transfered(block.timestamp, _tokenId, msg.sender, _to);
    }
    
        //only owner 
    function setNFTContractAddress(address _to) public onlyOwner {
      NFTContractAddress = _to;
    }

}
