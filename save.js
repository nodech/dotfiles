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
    async.each(files, COPY_FILES, function (error) {
      message('END COPYING');
      done(error);
    });
  },
  function (done) {
    message('TMUX STUFF');
    async.series([
      installTmuxPackageManager,
      installTmuxPackages
    ], function (error) {
      if (error) {
        console.error(error);
      }
      message('FINISHED TMUX STUFF');
      done();
    });
  },
  function (done) {
    message('VIM STUFF');
    async.series([
      installVimPackages,
      installTernForVim
    ], function (error) {
      if (error) {
        console.error(error);
      }
      message('END OF VIM STUFF');
      done();
    });
  }
], function (error, done) {
  if (error) {
    console.error(error);
  }
  message('DONE');
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
    done();
  });
};

function installVimPackages(done) {
  exec('vim +PluginInstall +qall', function (error, stdout, stderr) {
    if (error) {
      done(error);
      return;
    }

    LOG(stdout, stderr);
    message('INSTALLED VUNDLE PACKAGES');
    done();
  });
}

function installTernForVim(done) {
  exec('cd ~/.vim/bundle/tern_for_vim && npm install', function (error, stdout, stderr) {
    if (error) {
      done(error);
      return;
    }

    LOG(stdout, stderr);
    message('INSTALLED TERN_FOR_VIM npm modules');
    done();
  });
}

function COPY_FILES(file, done) {
  exec('cp -rv "' + file + '" "' + homeDir + '/"', function (error, stdout, stderr) {
    if (error) {
      done(error);
      return;
    }

    LOG(stdout, stderr);
    done();
  });
};

function LOG(out, err) {
  console.log(out);
  console.error(err);
}
