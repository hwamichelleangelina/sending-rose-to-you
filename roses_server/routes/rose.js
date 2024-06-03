const express = require('express');
const routerRose = express.Router();
const roseController = require('../controllers/rose');

routerRose.post('/', (req, res) => {
    res.status(200).json('Server on Port 5000 and Database roses has been connected.');
});

routerRose.post('/send-rose', roseController.sendRose);
routerRose.get('/my-roses/:username', roseController.getRoses);
routerRose.get('/get-rose/:roseid', roseController.getRose);

module.exports = routerRose;
