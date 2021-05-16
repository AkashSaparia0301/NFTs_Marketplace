const TicketNFTData = artifacts.require("./TicketNFTData.sol");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(TicketNFTData);
};
