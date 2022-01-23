const fs = require('fs');
const Handlebars = require('handlebars');
const { resolve } = require('path');

require('dotenv').config();

console.log('Starting Injecter...\n');

const MISSING_ENVS = [
    'TEMPLATE',
    'SLACK_HOOK',
    'GOOGLE_CLIENT_ID',
    'SLACK_LINK',
].filter((e) => !process.env[e]);

if (MISSING_ENVS.length > 0)
    throw (
        '☹   yikes! It looks like you have some missing env variables: \n\n' +
        MISSING_ENVS.reduce(
            (acc, _var) => (acc += '❌  Missing ENV --> ' + _var + '\n'),
            ''
        ) +
        '\n------------------------------\n\n✖  Build Failed!'
    );

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
        slackLink: process.env.SLACK_LINK,
    })
);

console.log('       * ---> build/index.html');
console.log('\n------------------------------\n');
console.log('✔ Build Finished\n');
