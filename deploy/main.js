const hre = require("hardhat");
async function main() {
    
    const tokenA = "0xDAe19Ec940cE2Fb0F53066cd5D6CdB1c2682ECE6"; // Your deployed TokenA address
    const tokenB = "0x8712861EB1fD9ae9b6aeDb279159F8028504211e"; // Your deployed TokenB address
    const uniswapRouter = "0x667387AD0842Fb68a1cF0DD8c968DE958DD0eA72"; // Uniswap Router address
    const uniswapFactory = "0x1D0745C83d0F335Ce943a3313C2E00c75BD5b77c"; // Uniswap Factory address

    
    const contract = await ethers.getContractFactory("New");
    const contractInstance = await contract.deploy(uniswapRouter, uniswapFactory, tokenA, tokenB);
    await contractInstance.waitForDeployment();

    const contractAddress = await contractInstance.getAddress();

    console.log("contract smart contract address: ", contractAddress);

}


// Run the deployment function
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });