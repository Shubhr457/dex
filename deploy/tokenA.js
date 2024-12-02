const { ethers } = require("hardhat");

const main = async () => {
    const [owner] = await ethers.getSigners();

    console.log(owner.address);

    const tokenA = await ethers.getContractFactory("ERC20");

    const tokenAInstance = await tokenA.deploy(50000000000000000000000n);

    await tokenAInstance.waitForDeployment();

    const tokenAAddress = await tokenAInstance.getAddress();

    console.log("tokenA smart contract address: ", tokenAAddress);
};

main().catch((e) => {
    console.log(e);
    process.exit(1);
});
