#!/usr/bin/env node

var path = require('path'),
    fs = require('fs'),
    exec = require('child_process').exec,
    files = fs.readdirSync(__dirname),
    async = require('async'),
    util = require('util'),
    exclude = [ 'save.js', '.git', 'README.md', '.gitignore', 'package.json', 'node_modules', 'save.sh', 'npm-debug.log' ],
    homeDir = path.resolve(process.env['HOME']),
    message = console.log.bind(null, '======= %s =======');


files = files.filter(function (file) {
  return exclude.indexOf(file) < 0;
});

async.series([
  function (done) {
    message('START COPYING');
    async.each(files, function (file, callback) {
      exec('cp -rv "' + file + '" "' + homeDir + '/"', function (error, stdout, stderr) {
        console.log('cp -rv "' + file + '" "' + homeDir + '/"');
        if (error) {
          callback(error);
          return
        }

        LOG(stdout, stderr);
        callback();
      });
    }, done);
  },
  function (done) {
    message('TMUX STUFF');
    async.series([
      installTmuxPackageManager,
      installTmuxPackages
    ], function (error) {
      message('FINISHED TMUX STUFF');
      done(error);
    });
  }
], function (error, done) {
});

function installTmuxPackageManager(done) {
  exec('git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm', function (error, stdout, stderr) {
    if (error) {
      done(error);
      return;
    }

    LOG(stdout, stderr);
    message('INSTALLED TMUX PACKAGE MANAGER');
    done();
  });
}

function installTmuxPackages(done) {
  exec('~/.tmux/plugins/tpm/scripts/install_plugins.sh', function (error, stdout, stderr) {
    if (error) {
      done(error);
      return;
    }

    LOG(stdout, stderr);
    message('INSTALLED TMUX PACKAGES');
  });
};

function LOG(out, err) {
  console.log(out);
  console.error(err);
}
