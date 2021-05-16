pragma solidity ^0.5.0;

import { TicketNFT } from "../../TicketNFT.sol";


contract TicketNFTMarketplaceEvents {

    event TicketNFTOwnershipChanged (
        TicketNFT ticketNFT,
        uint ticketId, 
        address ownerBeforeOwnershipTransferred,
        address ownerAfterOwnershipTransferred
    );

}
