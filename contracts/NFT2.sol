//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract NFT2 is ERC721, Ownable, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    address private NFTMarketplaceAddress;

    constructor () ERC721("NFT2", "NFT2") {}
  
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://BASEURI";
    }

    function mint() public payable {
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();
        setApprovalForAll(NFTMarketplaceAddress, true);
    }

        //only owner 
    function setNFTMarketplaceAddress(address _to) public onlyOwner {
      NFTMarketplaceAddress = _to;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
