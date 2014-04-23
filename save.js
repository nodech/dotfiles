#!/usr/bin/env node

var path = require('path'),
    fs = require('fs'),
    exec = require('child_process').exec,
    files = fs.readdirSync(__dirname),
    exclude = [ 'save.js', '.git', 'README.md' ],
    homeDir = path.resolve(process.env['HOME']);

files = files.filter(function (file) {
  return exclude.indexOf(file) < 0;
});

files.forEach(function (file) {
  exec('cp -rv "' + file + '" "' + homeDir + '/"', function (error, stdout, stderr) {
    console.log('cp -rv "' + file + '" "' + homeDir + '/"');
    if (error) {
      throw error;
    }

    if (stderr) {
      console.error(stderr);
    } else {
      console.log(stdout);
    }
  });
});
