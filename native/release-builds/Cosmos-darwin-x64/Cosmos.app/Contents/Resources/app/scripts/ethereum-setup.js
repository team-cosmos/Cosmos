// ethereum-setup.js

const ethUtils = require('./ethereum-utils');
const _password = "cosmos";
const _address = "6f753d32768d47b98327e3fb1829b7a62006c71c";

/* Set up web3 */
const ethClient = "https://ropsten.infura.io/ynXBPNoUYJ3C4ZDzqjga";
var Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider(ethClient));

// const ethTx = require('ethereumjs-tx');

// const txParams = {
//   nonce: '0x6', // Replace by nonce for your account on geth node
//   gasPrice: '0x09184e72a000', 
//   gasLimit: '0x30000',
//   to: '0xfa3caabc8eefec2b5e2895e5afbf79379e7268a7', 
//   value: '0x00'
// };
// // Transaction is created
// const tx = new ethTx(txParams);

// const privKey = Buffer.from('3656e131f04ddb9eaf206b2859f423c8260bdff9d7b1a071b06d405f50ed3fa0', 'hex');
// // Transaction is signed
// tx.sign(privKey);
// const serializedTx = tx.serialize();
// const rawTx = '0x' + serializedTx.toString('hex');
// console.log(rawTx)

// web3.eth.sendSignedTransaction(rawTx);

// var nonce = web3.eth.getTransactionCount('0x929FFF0071a12d66b9d2A90f8c3A6699551E91e3);