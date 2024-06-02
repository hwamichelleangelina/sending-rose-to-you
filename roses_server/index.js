const express = require('express');
const bodyParser = require('body-parser');
const routerUser = require('./routes/auth');

const app = require('./app');
const cors = require('cors');
app.use(bodyParser.json());

app.use('/auth', routerUser);

app.listen(5000, () => {
    console.log('Server running on port 5000');
});