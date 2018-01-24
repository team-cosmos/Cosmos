// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

require('./scripts/ethereum.js');
var remote = require('electron').remote;
var Menu = remote.Menu;
var MenuItem = remote.MenuItem;

// Build our new menu
var menu = new Menu()
menu.append(new MenuItem({
  label: 'Delete',
  click: function() {
    // Trigger an alert when menu item is clicked
    alert('Deleted')
  }
}))
menu.append(new MenuItem({
  label: 'More Info...',
  click: function() {
    // Trigger an alert when menu item is clicked
    alert('Here is more information')
  }
}))

// Add the listener
document.addEventListener('DOMContentLoaded', function () {
  var nodeList = document.querySelectorAll('.js-context-menu')

  Array.prototype.forEach.call(nodeList, function (item) {
    item.addEventListener('contextmenu', function (event) {
      menu.popup(remote.getCurrentWindow());
    })
  })
})

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