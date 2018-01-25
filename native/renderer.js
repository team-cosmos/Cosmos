// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

require('./scripts/setup.js');
const ethUtils = require('./scripts/ethereum-utils');

// New meter.
document.getElementById('new-meter-button').addEventListener("click", function() {
  var wallet = ethUtils.createWallet(Math.random().toString(36));
    document.getElementById('meter-public-key').innerHTML = 
      "Public Key: " + wallet.getPublicKeyString();
}, false);

// Send energy.
document.getElementById('send-energy-button').addEventListener("click", function() {
    document.getElementById('latest-block').innerHTML = web3.eth.blockNumber;
}, false);

