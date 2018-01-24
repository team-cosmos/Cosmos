// ethereum-utils.js

var keythereum = require("keythereum");
var ethereumUtil = require('ethereumjs-util')

// Todo 
> const util = require('ethereumjs-util')
> util.privateToPublic(privateKey)
//

var createKeySync = function() {
  var params = { keyBytes: 32, ivBytes: 16 };

  return newKey = keythereum.create(params);
}

var dumpKeyAsync = function(password) {
  var kdf = "pbkdf2"; // or "scrypt" to use the scrypt kdf

  var options = {
    kdf: "pbkdf2",
    cipher: "aes-128-ctr",
    kdfparams: {
      c: 262144,
      dklen: 32,
      prf: "hmac-sha256"
    }
  };

  keythereum.dump(
    password, newKey.privateKey, 
    newKey.salt, newKey.iv, options, 
    function (keyObject) {
      keythereum.exportToFile(keyObject);
    });
}

var importKeySync = function(address, password) {
  var datadir = "./";
  var keyObject = keythereum.importFromFile(address, datadir);
  return privateKey = keythereum.recover(password, keyObject);
}

module.exports = {
    createKeySync: createKeySync,
    dumpKeyAsync: dumpKeyAsync,
    importKeySync: importKeySync
};