//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract SIMPLETEST is ERC721, Ownable, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    // Base URI
    string private _baseURIextended;
    
    address private NFTMarketplaceAddress;

    constructor () ERC721("SIMPLETEST", "Test1") {}
    
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function mint(address to) public payable {
        _safeMint(to, _tokenIdCounter.current());
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
