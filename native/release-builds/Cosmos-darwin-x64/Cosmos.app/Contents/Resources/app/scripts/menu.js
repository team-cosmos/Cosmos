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