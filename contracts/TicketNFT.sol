pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { ERC721Full } from "./openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import { SafeMath } from "./openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @notice - This is the NFT contract for a Ticket
 */
contract TicketNFT is ERC721Full {
    using SafeMath for uint256;

    uint256 public currentTicketId;
    
    constructor(
        address owner,  /// Initial owner (Seller)
        string memory _nftName, 
        string memory _nftSymbol,
        string memory _tokenURI,    /// [Note]: TokenURI is URL include ipfs hash
        uint ticketPrice
    ) 
        public 
        ERC721Full(_nftName, _nftSymbol) 
    {
        mint(owner, _tokenURI);
    }

    /** 
     * @dev mint a ticketNFT
     * @dev tokenURI - URL include ipfs hash
     */

    function mint(address to, string memory tokenURI) public returns (bool) {
        /// Mint a new TicketNFT
        uint newTicketId = getNextTicketId();
        currentTicketId++;
        _mint(to, newTicketId);
        _setTokenURI(newTicketId, tokenURI);
    }


    ///--------------------------------------
    /// Getter methods
    ///--------------------------------------


    ///--------------------------------------
    /// Private methods
    ///--------------------------------------
    function getNextTicketId() private returns (uint nextTicketId) {
        return currentTicketId.add(1);
    }
    

}
