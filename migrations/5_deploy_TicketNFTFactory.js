const TicketNFTFactory = artifacts.require("./TicketNFTFactory.sol");
const TicketNFTMarketPlace = artifacts.require("./TicketNFTMarketPlace.sol");
const TicketNFTData = artifacts.require("./TicketNFTData.sol");

const _TicketNFTMarketPlace = TicketNFTMarketPlace.address;
const _TicketNFTData = TicketNFTData.address;

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(TicketNFTFactory, _TicketNFTMarketPlace, _TicketNFTData);
};
