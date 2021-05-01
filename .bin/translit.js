#!/usr/bin/env node

const geo = {
  'ა': 'a',
  'ბ': 'b',
  'გ': 'g',
  'დ': 'd',
  'ე': 'e',
  'ვ': 'v',
  'ზ': 'z',
  'თ': 't',
  'ი': 'i',
  'კ': 'k',
  'ლ': 'l',
  'მ': 'm',
  'ნ': 'n',
  'ო': 'o',
  'პ': 'p',
  'ჟ': 'j',
  'რ': 'r',
  'ს': 's',
  'ტ': 't',
  'უ': 'u',
  'ფ': 'f',
  'ქ': 'q',
  'ღ': 'gh',
  'ყ': 'kh',
  'შ': 'sh',
  'ჩ': 'ch',
  'ც': 'c',
  'ძ': 'dz',
  'წ': 'ts',
  'ჭ': 'tch',
  'ხ': 'kh',
  'ჯ': 'j',
  'ჰ': 'h',
  '-': '_',
  ' ': '-',
}

const out = [];
for (const text of process.argv.slice(2))
  out = translit(text);
console.log(out.join(' '));

function translit(text) {
  for (let [from, to] of Object.entries(geo))
    text = text.replace(new RegExp(`${from}`, 'g'), to);
  return text;
}
