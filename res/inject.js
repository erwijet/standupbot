const fs = require('fs');
const Handlebars = require('handlebars');
const { resolve } = require('path');

require('dotenv').config();

console.log('Starting Injecter...\n');

if (
    !process.env.TEMPLATE ||
    !process.env.SLACK_HOOK ||
    !process.env.GOOGLE_CLIENT_ID
)
    throw "❌ It doens't look like you have defined a TEMPLATE, GOOGLE_CLIENT_ID, and SLACK_HOOK env var ";

const slackTemplate = fs
    .readFileSync(resolve(__dirname, '..', process.env.TEMPLATE))
    .toString();

const hbsFile = fs.readFileSync(resolve(__dirname, 'index.hbs')).toString();
const hbsTemplate = Handlebars.compile(hbsFile);

fs.writeFileSync(
    resolve(__dirname, '..', 'build', 'index.html'),
    hbsTemplate({
        slackTemplate: JSON.stringify(JSON.parse(slackTemplate)),
        slackHook: process.env.SLACK_HOOK,
        g_clientId: process.env.GOOGLE_CLIENT_ID,
    })
);

console.log('       * ---> build/index.html');
console.log('\n------------------------------\n');
console.log('✔ Build Finished\n');
