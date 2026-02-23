#!/usr/bin/env node

import { promises as fs } from 'node:fs';
import path from 'node:path';
import util from 'node:util';
import { exec as execCb } from 'node:child_process';

const exec = util.promisify(execCb);

const TASKS_DIR = path.join(process.env.HOME || '', '.local', 'share', 'waytasks');
const SHOW_ITEMS = 3;
const DEFAULT_TMUX = 6;
const DEFAULT_WAYBAR = 3;

const SUCCESS_LOGO_1 = "✅";
// const SUCCESS_LOGO_2 = "";
const SUCCESS_COLOR = "#28cd41";
const SUCCESS_TEXT_COLOR = "#28cd41";

const FAIL_LOGO_1 = "❌";
const FAIL_COLOR = "#f53c3c";
const FAIL_TEXT_COLOR = "#f53c3c";

const RUNNING_LOGO_1 = "🔄";
const RUNNING_COLOR = "#f9e2af";
const RUNNING_TEXT_COLOR = "#f9e2af";

const ABORTED_LOGO_1 = "✖️";
const ABORTED_COLOR = "#808080";
const ABORTED_TEXT_COLOR = "#808080";

const aliases = {};

const allTasks = await Promise.all(
  (await fs.readdir(TASKS_DIR))
    .filter(f => f.endsWith('.json'))
    .map(async (f) => {
      const b = await fs.readFile(path.join(TASKS_DIR, f))
      const parsed = JSON.parse(b.toString());
      return [f, parsed];
    })
);

if (allTasks.length === 0) {
  process.exit(0);
}

// clean up older than 2 minute tasks.
const TIMEOUT = 2 * 60 * 1000;

for (const [filename, task] of allTasks) {
  if (task.status === 'running' && await isRunning(task)) {
    continue;
  }

  const now = Date.now();
  const taskEndTime = +task.end_time * 1000;
  const endtime = new Date(taskEndTime);

  if (isNaN(taskEndTime) || endtime.getTime() + TIMEOUT < now) {
    try {
      await fs.unlink(path.join(TASKS_DIR, filename));
    } catch (e) {
      ;
    }
  }
}

async function isRunning(task) {
  try {
    await exec(`ps -p ${task.pid} --no-headers -eo pid,comm`);
    return true;
  } catch (e) {
    return false;
  }
}

function printWaybar(maxItems = SHOW_ITEMS) {
  const result = {
    text: ' ',
    tooltip: '',
    alt: '',
    // class: '',
    // percentage: 0,
  };

  const results = [];

  const sums = {
    running: 0,
    fail: 0,
    success: 0,
    aborted: 0,
  };

  for (const [, task] of allTasks) {
    let textColor, icon, iconColor;

    switch (task.status) {
      case 'running': {
        icon = RUNNING_LOGO_1;
        iconColor = RUNNING_COLOR;
        textColor = RUNNING_TEXT_COLOR;
        sums.running++;
        break;
      }
      case 'failed': {
        icon = FAIL_LOGO_1;
        iconColor = FAIL_COLOR;
        textColor = FAIL_TEXT_COLOR;
        sums.fail++;
        break;
      }
      case 'success': {
        icon = SUCCESS_LOGO_1;
        iconColor = SUCCESS_COLOR;
        textColor = SUCCESS_TEXT_COLOR;
        sums.success++;
        break;
      }
      case 'aborted': {
        icon = ABORTED_LOGO_1;
        iconColor = ABORTED_COLOR;
        textColor = ABORTED_TEXT_COLOR;
        sums.aborted++;
        break;
      }
      default: {
        icon = "❓";
        iconColor = "#ff00ff";
        textColor = "#ff00ff";
        break;
      }
    }

    results.push({
      text: `<span color='${iconColor}'>${icon}</span><span color='${textColor}'>${formatName(task.name)}</span>`,
      tooltip: `<span color='${iconColor}'>${icon}</span> <span color='${textColor}'>${task.name} (${task.pid})</span> - ${task.cwd}\n`
        + `  ${task.command}`
    });
  }

  result.tooltip = results.map(r => r.tooltip).join('\n').trim();

  if (results.length > maxItems + 1) {
    const left = results.length - maxItems;
    result.text = `..${left}.. ` + results.slice(-maxItems).map(r => r.text).join(' ').trim();
  } else {
    result.text = results.map(r => r.text).join(' ').trim();
  }

  if (sums.success)
    result.alt += ` <span color='${SUCCESS_COLOR}'>${SUCCESS_LOGO_1}</span> <span color='${SUCCESS_TEXT_COLOR}'>${sums.success}</span>`;
  if (sums.running)
    result.alt += ` <span color='${RUNNING_COLOR}'>${RUNNING_LOGO_1}</span> <span color='${RUNNING_TEXT_COLOR}'>${sums.running}</span>`;
  if (sums.fail)
    result.alt += ` <span color='${FAIL_COLOR}'>${FAIL_LOGO_1}</span> <span color='${FAIL_TEXT_COLOR}'>${sums.fail}</span>`;
  if (sums.aborted)
    result.alt += ` <span color='${ABORTED_COLOR}'>${ABORTED_LOGO_1}</span> <span color='${ABORTED_TEXT_COLOR}'>${sums.aborted}</span>`;

  result.alt = result.alt.trim();

  console.log(JSON.stringify(result));
}

function printTmux(maxItems = SHOW_ITEMS) {
  const sums = {
    running: 0,
    fail: 0,
    success: 0,
    aborted: 0,
  };

  const output = [];

  for (const [, task] of allTasks) {
    let textColor, icon, iconColor;

    switch (task.status) {
      case 'running': {
        icon = RUNNING_LOGO_1;
        iconColor = RUNNING_COLOR;
        textColor = RUNNING_TEXT_COLOR;
        sums.running++;
        break;
      }
      case 'failed': {
        icon = FAIL_LOGO_1;
        iconColor = FAIL_COLOR;
        textColor = FAIL_TEXT_COLOR;
        sums.fail++;
        break;
      }
      case 'success': {
        icon = SUCCESS_LOGO_1;
        iconColor = SUCCESS_COLOR;
        textColor = SUCCESS_TEXT_COLOR;
        sums.success++;
        break;
      }
      case 'aborted': {
        icon = FAIL_LOGO_1;
        iconColor = ABORTED_COLOR;
        textColor = ABORTED_TEXT_COLOR;
        sums.aborted++;
        break;
      }
      default: {
        icon = "❓";
        iconColor = "#ff00ff";
        textColor = "#ff00ff";
        break;
      }
    }

    output.push(`#[fg=${iconColor}]${icon}#[fg=${textColor}]${formatName(task.name)}`);
  }

  const final = [];

  if (output.length > maxItems)
    final.push('...');

  final.push(...output.slice(-maxItems));
  const finalOutput = final.join(' | ');
  console.log(finalOutput);
}

if (process.argv.includes('--tmux')) {
  // If running in tmux, print the tmux output.
  printTmux(DEFAULT_TMUX);
  process.exit(0);
}

printWaybar(DEFAULT_WAYBAR);

function formatName(name) {
  if (name in aliases) {
    return aliases[name];
  }

  return name;
}
