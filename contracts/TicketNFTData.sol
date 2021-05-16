pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { TicketNFTDataStorages } from "./Ticket-nft-data/commons/TicketNFTDataStorages.sol";
import { TicketNFT } from "./TicketNFT.sol";


/**
 * @notice - This is the storage contract for TicketNFTs
 */
contract TicketNFTData is TicketNFTDataStorages {

    address[] public TicketAddresses;

    constructor() public {}

    /**
     * @notice - Save metadata of a TicketNFT
     */
    function saveMetadataOfTicketNFT(
        address[] memory _TicketAddresses, 
        TicketNFT _TicketNFT, 
        string memory _TicketNFTName, 
        string memory _TicketNFTSymbol, 
        address _ownerAddress, 
        uint _TicketPrice, 
        string memory _ipfsHashOfTicket
    ) public returns (bool) {
        /// Save metadata of a TicketNFT of Ticket
        Ticket memory Ticket = Ticket({
            TicketNFT: _TicketNFT,
            TicketNFTName: _TicketNFTName,
            TicketNFTSymbol: _TicketNFTSymbol,
            ownerAddress: _ownerAddress,
            TicketPrice: _TicketPrice,
            ipfsHashOfTicket: _ipfsHashOfTicket,
            status: "Open",
            reputation: 0
        });
        Tickets.push(Ticket);

        /// Update TicketAddresses
        TicketAddresses = _TicketAddresses;     
    }

    /**
     * @notice - Update owner address of a TicketNFT by transferring ownership
     */
    function updateOwnerOfTicketNFT(TicketNFT _TicketNFT, address _newOwner) public returns (bool) {
        /// Identify Ticket's index
        uint TicketIndex = getTicketIndex(_TicketNFT);

        /// Update metadata of a TicketNFT of Ticket
        Ticket storage Ticket = Tickets[TicketIndex];
        require (_newOwner != address(0), "A new owner address should be not empty");
        Ticket.ownerAddress = _newOwner;  
    }

    /**
     * @notice - Update status ("Open" or "Cancelled")
     */
    function updateStatus(TicketNFT _TicketNFT, string memory _newStatus) public returns (bool) {
        /// Identify Ticket's index
        uint TicketIndex = getTicketIndex(_TicketNFT);

        /// Update metadata of a TicketNFT of Ticket
        Ticket storage Ticket = Tickets[TicketIndex];
        Ticket.status = _newStatus;  
    }


    ///-----------------
    /// Getter methods
    ///-----------------
    function getTicket(uint index) public view returns (Ticket memory _Ticket) {
        Ticket memory Ticket = Tickets[index];
        return Ticket;
    }

    function getTicketIndex(TicketNFT TicketNFT) public view returns (uint _TicketIndex) {
        address Ticket_NFT = address(TicketNFT);

        /// Identify member's index
        uint TicketIndex;
        for (uint i=0; i < TicketAddresses.length; i++) {
            if (TicketAddresses[i] == Ticket_NFT) {
                TicketIndex = i;
            }
        }

        return TicketIndex;   
    }

    function getTicketByNFTAddress(TicketNFT TicketNFT) public view returns (Ticket memory _Ticket) {
        address Ticket_NFT = address(TicketNFT);

        /// Identify member's index
        uint TicketIndex;
        for (uint i=0; i < TicketAddresses.length; i++) {
            if (TicketAddresses[i] == Ticket_NFT) {
                TicketIndex = i;
            }
        }

        Ticket memory Ticket = Tickets[TicketIndex];
        return Ticket;
    }

    function getAllTickets() public view returns (Ticket[] memory _Tickets) {
        return Tickets;
    }

}
