pragma solidity ^0.5.0;

import { TicketNFT } from "../../TicketNFT.sol";


contract TicketNFTDataObjects {

    struct Ticket {  /// [Key]: index of array
        TicketNFT TicketNFT;
        string TicketNFTName;
        string TicketNFTSymbol;
        address ownerAddress;
        uint TicketPrice;
        string ipfsHashOfticket;
        string status;  /// "Open" or "Cancelled"
        uint256 reputation;
    }

}
