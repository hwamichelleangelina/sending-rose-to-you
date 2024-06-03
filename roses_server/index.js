const express = require('express');
const bodyParser = require('body-parser');
const routerUser = require('./routes/auth');

const app = require('./app');
const cors = require('cors');
const routerMessage = require('./routes/message');
const routerRose = require('./routes/rose');
app.use(bodyParser.json());

app.use('/auth', routerUser);
app.use('/messages', routerMessage);
app.use('/roses', routerRose);

app.listen(5000, () => {
    console.log('Server running on port 5000');
});