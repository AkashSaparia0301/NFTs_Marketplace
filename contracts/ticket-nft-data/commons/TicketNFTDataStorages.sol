pragma solidity ^0.5.0;

import { TicketNFTDataObjects } from "./TicketNFTDataObjects.sol";


// shared storage
contract TicketNFTDataStorages is TicketNFTDataObjects {

    Ticket[] public tickets;

}

