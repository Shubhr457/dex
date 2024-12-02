require("@nomicfoundation/hardhat-toolbox");

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
      accounts:["eedd5eed4e6aab6ae6987b0dd6e700890907e2ee21c080037430bfe44cdf82d7"]
    }
  }
};
