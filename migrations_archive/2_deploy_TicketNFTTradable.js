const TicketNFTTradable = artifacts.require("./TicketNFTTradable.sol");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(TicketNFTTradable);
};
