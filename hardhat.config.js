require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity:"0.8.20",
  //  {
  //   compilers: [{
  //     version: "0.5.16",
  //     settings: {
  //       optimizer: {
  //         enabled: true,
  //         runs: 1000,
  //       },
  //     },
  //   },
  //   {
  //     version: "0.6.6",
  //     settings: {
  //       optimizer: {
  //         enabled: true,
  //         runs: 1000,
  //       },
  //     },
  //   }],
  // },
  networks:{
    amoy:{
      url:`${process.env.POLYGON_AMOY_RPC_URL}`,
      accounts:[`${process.env.PRIVATE_KEY}`]
    }
  }
};
