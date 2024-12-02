const { ethers } = require("hardhat");

const main = async () => {
    const [owner] = await ethers.getSigners();

    console.log(owner.address);

    const router = await ethers.getContractFactory("UniswapV2Router02");

    const routerInstance = await router.deploy("0x1D0745C83d0F335Ce943a3313C2E00c75BD5b77c","0xdF9f28536afAA08A56C26b71327C03B3b956cA6B");

    await routerInstance.waitForDeployment();

    const routerAddress = await routerInstance.getAddress();

    console.log("router smart contract address: ", routerAddress);
};

main().catch((e) => {
    console.log(e);
    process.exit(1);
});
