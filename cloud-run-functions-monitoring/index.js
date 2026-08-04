const functions = require('@google-cloud/functions-framework');

functions.http('helloworld', (req, res) => {
  res.send('Hello World!');
});
