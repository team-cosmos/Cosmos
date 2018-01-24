// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

require('./scripts/setup.js');

// Block info UI.
document.getElementById('latest-block-button').addEventListener("click", function() {
    document.getElementById('latest-block').innerHTML = web3.eth.blockNumber;
}, false);

// New meter.
document.getElementById('new-meter-button').addEventListener("click", function() {
    document.getElementById('latest-block').innerHTML = web3.eth.blockNumber;
}, false);

// Send energy.
document.getElementById('send-energy-button').addEventListener("click", function() {
    document.getElementById('latest-block').innerHTML = web3.eth.blockNumber;
}, false);

