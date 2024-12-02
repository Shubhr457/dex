const { ethers } = require("hardhat");

const main = async () => {
    const [owner] = await ethers.getSigners();

    console.log(owner.address);

    const tokenB = await ethers.getContractFactory("ERC20");

    const tokenBInstance = await tokenB.deploy(40000000000000000000000n);

    await tokenBInstance.waitForDeployment();

    const tokenBAddress = await tokenBInstance.getAddress();

    console.log("tokenB smart contract address: ", tokenBAddress);
};

main().catch((e) => {
    console.log(e);
    process.exit(1);
});
