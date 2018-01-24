web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/ynXBPNoUYJ3C4ZDzqjga"));

function printAccountBalance() {
  var GET = {};
  var query = window.location.search.substring(1).split("&");
  for (var i = 0, max = query.length; i < max; i++) {
      if (query[i] === "") // check for trailing & with no param
          continue;
      var param = query[i].split("=");
      GET[decodeURIComponent(param[0])] = decodeURIComponent(param[1] || "");
  }
  var account = GET.account;

  var balanceWei = web3.eth.getBalance(account).toNumber();
  var balance = web3.fromWei(balanceWei, 'ether');

  document.write('[' + account + ']<br><br>')
  document.write(balance + ' Ether');         
}