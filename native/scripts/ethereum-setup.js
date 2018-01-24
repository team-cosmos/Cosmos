// ethereum-setup.js

const ethUtils = require('./ethereum-utils');

/* Set up web3 */
const ethClient = "https://ropsten.infura.io/ynXBPNoUYJ3C4ZDzqjga";
var Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider(ethClient));

/* Set up account */
var key = ethUtils.createKeySync();
ethUtils.dumpKeyAsync("cosmos");
