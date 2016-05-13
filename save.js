#!/usr/bin/env node

let path = require('path');
let util = require('util');

let spawnSync = require('child_process').spawnSync;
let spawn = require('child_process').spawn;
let exec = require('mz/child_process').exec;
let fs = require('mz/fs');

let co  = require('co');

let inquirer = require('inquirer');

let HOME_DIR = path.resolve(process.env['HOME']);
let FILES = fs.readdirSync(__dirname);


var HEAD = ' ======== ';
var head = ' ----- ';
var MSG = (str, ...args) => console.log(HEAD + str.toUpperCase() + HEAD, ...args)
var msg = (str, ...args) => console.log(head + str + head, ...args)
let log = console.log;

var exclude = [
 '.git',
 '.gitignore',
 '.gitmodules',
 'README.md',

 'node_modules',
 'package.json',
 'npm-debug.log',

 'save.sh',
  'save.js',
 'vim.sh',

 'BREW_CASK_LIST',
 'BREW_PACKAGES'
];

FILES = FILES.filter((file) => exclude.indexOf(file) < 0)


let TASKS = [
  copyFiles,
  brew,
  brewCask,
  tmuxPlugInstall,
];

let TASKS_NAMES = TASKS.map(getTaskObject);

let promptConfigs = [{
  name : 'tasks',
  type : 'checkbox',
  message : 'Choose Tasks to run',
  choices : TASKS_NAMES
}];

co(function *() {
  MSG('Starting setup');

  let prompt = yield inquirer.prompt(promptConfigs);
  let tasks = prompt.tasks;

  for (let i = 0, task; i < tasks.length; i++) {
    task = tasks[i];

    MSG('Starting:' + task.name);

    yield co(task.task);

    MSG('Ended:' + task.name)
    log('');
  }

}).catch((err) => {
  MSG('error');
  msg(err);
});

function getTaskName(taskGen) {
  let fn = taskGen.toString().split("\n");
  let name = fn[1].match(/^\s+\/\/(.*)/);

  return name[1];
}

function getTaskObject(taskGen) {
  let name = getTaskName(taskGen);
  let id = name.split(':')[0].trim();

  return {
    name : name,
    value : {
      id : id,
      name : name,
      task : taskGen
    },
    checked : true
  };
}

function promiseFn() {
  var promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve(), 1000);
  })

  return promise;
}

function *copyFiles(tasks) {
  //copy-files: Copy Files
 
  msg('starting copying');

  let prompt = yield inquirer.prompt({
    name : 'files',
    type : 'checkbox',
    message : 'Choose files to copy(recursively)',
    choices : FILES,
    default : FILES
  });

  let files = prompt.files;
  let copy = files.map((file) => {
    let cmd = 'cp -rv "' + file + '" "' + HOME_DIR + '"';
    log(cmd);
    return exec('cp -rv "' + file + '" "' + HOME_DIR + '"');
  })

  let results = yield copy;
  results.forEach((result) => log(...result))
}

function *brew(tasks) {
  //brew: Install BREW_PACKAGES(requires brew)
  msg('installing brew packages');

  let packages = fs.readFileSync('./BREW_PACKAGES').toString().split("\n");
  packages.forEach((package) => {
    package = package.trim();
    msg('brew install ' + package);

    spawnSync('brew', [ 'install', package ], {
      stdio : 'inherit'
    });
  });

  msg('brew packages done');

  return 'brew installed';
}

function *brewCask(tasks) {
  //brew-cask: Install BRAW_CASK_LIST(requires brew-cask)
  msg('installing brew cask apps');

  let packages = fs.readFileSync('./BREW_CASK_LIST').toString().split("\n");
  packages.forEach((package) => {
    package = package.trim();
    msg('brew cask install' + package);

    spawnSync('brew', [ 'cask', 'install', package ], {
      stdio : 'inherit'
    })
  });

  msg('brew cask apps done')

  return 'brew cask installed';
}

function *tmuxPlugInstall(tasks) {
  //tmux-plug: Install TMUX Plugins

  let dest = HOME_DIR + '/.tmux/plugins/tpm';

  var exists = yield fs.exists(dest)
  if (!exists) {
    msg('get tmux tpm')
    let got = yield exec('git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm');
    log(got.join("\n"));
  } else {
    msg(dest + ' already exists');
  }


  msg('install plugins');
  spawnSync('bash', [HOME_DIR + '/.tmux/plugins/tpm/scripts/install_plugins.sh'], {
    stdio : 'inherit'
  });
}
