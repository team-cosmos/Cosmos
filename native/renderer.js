// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

require('./scripts/setup.js');
const ethUtils = require('./scripts/ethereum-utils');

// New meter.
document.getElementById('new-meter-button').addEventListener("click", function() {
  var wallet = ethUtils.createWallet(Math.random().toString(36));
    document.getElementById('meter-public-key').innerHTML = wallet.getPublicKeyString();
}, false);

// Send energy.
document.getElementById("send-energy").addEventListener("submit", function(event) { 
  event.preventDefault(); 
});

document.getElementById("energy-input").addEventListener('input', function (event) {
    if (this.value < 0) {
      this.value = 0;
    }
});