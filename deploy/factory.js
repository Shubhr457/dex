const { ethers } = require("hardhat");

const main = async () => {
    const [owner] = await ethers.getSigners();

    console.log(owner.address);

    const factory = await ethers.getContractFactory("UniswapV2Factory");

    const factoryInstance = await factory.deploy(owner.address);

    await factoryInstance.waitForDeployment();

    const factoryAddress = await factoryInstance.getAddress();

    console.log("Factory smart contract address: ", factoryAddress);
};

main().catch((e) => {
    console.log(e);
    process.exit(1);
});
