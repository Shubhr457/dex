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
      url:"https://polygon-amoy.g.alchemy.com/v2/YfWxvfSqt0WZfWRiOtXQvs-gaI9Kz0QI",
      accounts:[`0x${process.env.PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: {
          polygonAmoy:"V2YP4FYKXUCFNA3M38K1JCHT38EJPMDZE7"
    },
  },
};
