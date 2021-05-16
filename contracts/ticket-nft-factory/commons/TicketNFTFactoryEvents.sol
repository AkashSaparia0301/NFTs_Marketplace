pragma solidity ^0.5.0;

import { TicketNFT } from "../../TicketNFT.sol";


contract TicketNFTFactoryEvents {

    event TicketNFTCreated (
        address owner,
        TicketNFT ticketNFT,
        string nftName, 
        string nftSymbol, 
        uint ticketPrice, 
        string ipfsHashOfTicket
    );

    event AddReputation (
        uint256 tokenId,
        uint256 reputationCount
    );

}
