// ethereum-setup.js

const ethUtils = require('./ethereum-utils');
const _password = "cosmos";
const _address = "6f753d32768d47b98327e3fb1829b7a62006c71c";

/* Set up web3 */
const ethClient = "https://ropsten.infura.io/ynXBPNoUYJ3C4ZDzqjga";
var Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider(ethClient));



console.log(web3.eth.blockNumber)
// /* Set up account */
// var wallet = ethUtils.createWallet();
// console.log(wallet)
