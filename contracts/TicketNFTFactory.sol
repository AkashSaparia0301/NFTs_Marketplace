pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { SafeMath } from "./openzeppelin-solidity/contracts/math/SafeMath.sol";
import { Strings } from "./libraries/Strings.sol";
import { TicketNFTFactoryStorages } from "./Ticket-nft-factory/commons/TicketNFTFactoryStorages.sol";
import { TicketNFT } from "./TicketNFT.sol";
import { TicketNFTMarketplace } from "./TicketNFTMarketplace.sol";
import { TicketNFTData } from "./TicketNFTData.sol";


/**
 * @notice - This is the factory contract for a NFT of Ticket
 */
contract TicketNFTFactory is TicketNFTFactoryStorages {
    using SafeMath for uint256;
    using Strings for string;    

    address[] public TicketAddresses;
    address Ticket_NFT_MARKETPLACE;

    TicketNFTMarketplace public TicketNFTMarketplace;
    TicketNFTData public TicketNFTData;

    constructor(TicketNFTMarketplace _TicketNFTMarketplace, TicketNFTData _TicketNFTData) public {
        TicketNFTMarketplace = _TicketNFTMarketplace;
        TicketNFTData = _TicketNFTData;
        Ticket_NFT_MARKETPLACE = address(TicketNFTMarketplace);
    }

    /**
     * @notice - Create a new TicketNFT when a seller (owner) upload a Ticket onto IPFS
     */
    function createNewTicketNFT(string memory nftName, string memory nftSymbol, uint TicketPrice, string memory ipfsHashOfTicket) public returns (bool) {
        address owner = msg.sender;  /// [Note]: Initial owner of TicketNFT is msg.sender
        string memory tokenURI = getTokenURI(ipfsHashOfTicket);  /// [Note]: IPFS hash + URL
        TicketNFT TicketNFT = new TicketNFT(owner, nftName, nftSymbol, tokenURI, TicketPrice);
        TicketAddresses.push(address(TicketNFT));

        /// Save metadata of a TicketNFT created
        TicketNFTData.saveMetadataOfTicketNFT(TicketAddresses, TicketNFT, nftName, nftSymbol, msg.sender, TicketPrice, ipfsHashOfTicket);
        TicketNFTData.updateStatus(TicketNFT, "Open");

        emit TicketNFTCreated(msg.sender, TicketNFT, nftName, nftSymbol, TicketPrice, ipfsHashOfTicket);
    }


    ///-----------------
    /// Getter methods
    ///-----------------
    function baseTokenURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function getTokenURI(string memory _ipfsHashOfTicket) public view returns (string memory) {
        return Strings.strConcat(baseTokenURI(), _ipfsHashOfTicket);
    }

}
