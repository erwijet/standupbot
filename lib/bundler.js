const fs = require('fs');
const { resolve } = require('path');

require('dotenv').config();
const template = fs
    .readFileSync(resolve(__dirname, '..', process.env.TEMPLATE))
    .toString();

fs.writeFileSync(
    resolve(__dirname, '..', 'build', 'index.html'),
    `
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Main</title>
    <script src="elm.js"></script>
    </head>

    <body>
    <div id="myapp"></div>
    <script>
    var app = Elm.Main.init({
        node: document.getElementById('myapp'),
        flags: [
            '${JSON.stringify(JSON.parse(template))}',
            '${process.env.SLACK_HOOK}'
        ]
    });
    </script>
    </body>
    </html>
    `
);
