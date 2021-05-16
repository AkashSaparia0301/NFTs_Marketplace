pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

//import { ERC20 } from './openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import { SafeMath } from "./openzeppelin-solidity/contracts/math/SafeMath.sol";
import { TicketNFT } from "./TicketNFT.sol";
import { TicketNFTTradable } from "./TicketNFTTradable.sol";
import { TicketNFTMarketplaceEvents } from "./Ticket-nft-marketplace/commons/TicketNFTMarketplaceEvents.sol";
import { TicketNFTData } from "./TicketNFTData.sol";


contract TicketNFTMarketplace is TicketNFTTradable, TicketNFTMarketplaceEvents {
    using SafeMath for uint256;

    address public Ticket_NFT_MARKETPLACE;

    TicketNFTData public TicketNFTData;

    constructor(TicketNFTData _TicketNFTData) public TicketNFTTradable(_TicketNFTData) {
        TicketNFTData = _TicketNFTData;
        address payable Ticket_NFT_MARKETPLACE = address(uint160(address(this)));
    }

    /** 
     * @notice - Buy function is that buy NFT token and ownership transfer. (Reference from IERC721.sol)
     * @notice - msg.sender buy NFT with ETH (msg.value)
     * @notice - TicketID is always 1. Because each TicketNFT is unique.
     */
    function buyTicketNFT(TicketNFT _TicketNFT) public payable returns (bool) {
        TicketNFT TicketNFT = _TicketNFT;

        TicketNFTData.Ticket memory Ticket = TicketNFTData.getTicketByNFTAddress(TicketNFT);
        address _seller = Ticket.ownerAddress;                     /// Owner
        address payable seller = address(uint160(_seller));  /// Convert owner address with payable
        uint buyAmount = Ticket.TicketPrice;
        require (msg.value == buyAmount, "msg.value should be equal to the buyAmount");
 
        /// Bought-amount is transferred into a seller wallet
        seller.transfer(buyAmount);

        /// Approve a buyer address as a receiver before NFT's transferFrom method is executed
        address buyer = msg.sender;
        uint TicketId = 1;  /// [Note]: TicketID is always 1. Because each TicketNFT is unique.
        TicketNFT.approve(buyer, TicketId);

        address ownerBeforeOwnershipTransferred = TicketNFT.ownerOf(TicketId);

        /// Transfer Ownership of the TicketNFT from a seller to a buyer
        transferOwnershipOfTicketNFT(TicketNFT, TicketId, buyer);    
        TicketNFTData.updateOwnerOfTicketNFT(TicketNFT, buyer);
        TicketNFTData.updateStatus(TicketNFT, "Cancelled");

        /// Event for checking result of transferring ownership of a TicketNFT
        address ownerAfterOwnershipTransferred = TicketNFT.ownerOf(TicketId);
        emit TicketNFTOwnershipChanged(TicketNFT, TicketId, ownerBeforeOwnershipTransferred, ownerAfterOwnershipTransferred);

        /// Mint a Ticket with a new TicketId
        //string memory tokenURI = TicketNFTFactory.getTokenURI(TicketData.ipfsHashOfTicket);  /// [Note]: IPFS hash + URL
        //TicketNFT.mint(msg.sender, tokenURI);
    }


    ///-----------------------------------------------------
    /// Methods below are pending methods
    ///-----------------------------------------------------

    /** 
     * @dev reputation function is that gives reputation to a user who has ownership of being posted Ticket.
     * @dev Each user has reputation data in struct
     */
    function reputation(address from, address to, uint256 TicketId) public returns (uint256, uint256) {

        // Ticket storage Ticket = Tickets[TicketId];
        // Ticket.reputation = Ticket.reputation.add(1);

        // emit AddReputation(TicketId, Ticket.reputation);

        // return (TicketId, Ticket.reputation);
        return (0, 0);
    }
    

    function getReputationCount(uint256 TicketId) public view returns (uint256) {
        uint256 curretReputationCount;

        // Ticket memory Ticket = Tickets[TicketId];
        // curretReputationCount = Ticket.reputation;

        return curretReputationCount;
    }    

}
