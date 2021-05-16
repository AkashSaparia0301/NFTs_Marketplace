pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { TicketNFT } from "./TicketNFT.sol";
import { TicketNFTData } from "./TicketNFTData.sol";


/**
 * @title - TicketNFTTradable contract
 * @notice - This contract has role that put on sale of TicketNFTs
 */
contract TicketNFTTradable {
    event TradeStatusChange(uint256 ad, bytes32 status);

    TicketNFT public TicketNFT;
    TicketNFTData public TicketNFTData;

    struct Trade {
        address seller;
        uint256 TicketId;  /// TicketNFT's token ID
        uint256 TicketPrice;
        bytes32 status;   /// Open, Executed, Cancelled
    }
    mapping(uint256 => Trade) public trades;  /// [Key]: TicketNFT's token ID

    uint256 tradeCounter;

    constructor(TicketNFTData _TicketNFTData) public {
        TicketNFTData = _TicketNFTData;
        tradeCounter = 0;
    }

    /**
     * @notice - This method is only executed when a seller create a new TicketNFT
     * @dev Opens a new trade. Puts _TicketId in escrow.
     * @param _TicketId The id for the TicketId to trade.
     * @param _TicketPrice The amount of currency for which to trade the TicketId.
     */
    function openTradeWhenCreateNewTicketNFT(TicketNFT TicketNFT, uint256 _TicketId, uint256 _TicketPrice) public {
        TicketNFT.transferFrom(msg.sender, address(this), _TicketId);

        tradeCounter += 1;    /// [Note]: New. Trade count is started from "1". This is to align TicketId
        trades[tradeCounter] = Trade({
            seller: msg.sender,
            TicketId: _TicketId,
            TicketPrice: _TicketPrice,
            status: "Open"
        });
        //tradeCounter += 1;  /// [Note]: Original
        emit TradeStatusChange(tradeCounter - 1, "Open");
    }

    /**
     * @dev Opens a trade by the seller.
     */
    function openTrade(TicketNFT TicketNFT, uint256 _TicketId) public {
        TicketNFTData.updateStatus(TicketNFT, "Open");

        Trade storage trade = trades[_TicketId];
        require(
            msg.sender == trade.seller,
            "Trade can be open only by seller."
        );
        TicketNFT.transferFrom(msg.sender, address(this), trade.TicketId);
        trades[_TicketId].status = "Open";
        emit TradeStatusChange(_TicketId, "Open");
    }

    /**
     * @dev Cancels a trade by the seller.
     */
    function cancelTrade(TicketNFT TicketNFT, uint256 _TicketId) public {
        TicketNFTData.updateStatus(TicketNFT, "Cancelled");
        
        Trade storage trade = trades[_TicketId];
        require(
            msg.sender == trade.seller,
            "Trade can be cancelled only by seller."
        );
        require(trade.status == "Open", "Trade is not Open.");
        TicketNFT.transferFrom(address(this), trade.seller, trade.TicketId);
        trades[_TicketId].status = "Cancelled";
        emit TradeStatusChange(_TicketId, "Cancelled");
    }

    /**
     * @dev Executes a trade. Must have approved this contract to transfer the amount of currency specified to the seller. Transfers ownership of the TicketId to the filler.
     */
    function transferOwnershipOfTicketNFT(TicketNFT _TicketNFT, uint256 _TicketId, address _buyer) public {
        TicketNFT TicketNFT = _TicketNFT;

        Trade memory trade = getTrade(_TicketId);
        require(trade.status == "Open", "Trade is not Open.");

        _updateSeller(_TicketNFT, _TicketId, _buyer);

        TicketNFT.transferFrom(address(this), _buyer, trade.TicketId);
        getTrade(_TicketId).status = "Cancelled";
        emit TradeStatusChange(_TicketId, "Cancelled");
    }

    function _updateSeller(TicketNFT TicketNFT, uint256 _TicketId, address _newSeller) internal {
        Trade storage trade = trades[_TicketId];
        trade.seller = _newSeller;
    }


    /**
     * @dev - Returns the details for a trade.
     */
    function getTrade(uint256 _TicketId) public view returns (Trade memory trade_) {
        Trade memory trade = trades[_TicketId];
        return trade;
        //return (trade.seller, trade.TicketId, trade.TicketPrice, trade.status);
    }
}
