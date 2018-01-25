# Cosmos

## Native

When building native, if you get NODE_MODULE_VERSION mismatch error, run (in native/)

~~~~
npm install --save-dev electron-rebuild

# Every time you run "npm install", run this
./node_modules/.bin/electron-rebuild -v 1.7.2


# On Windows if you have trouble, try:
.\node_modules\.bin\electron-rebuild.cmd
~~~~