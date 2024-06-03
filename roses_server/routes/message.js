const express = require('express');
const routerMessage = express.Router();
const messController = require('../controllers/message');

routerMessage.post('/', (req, res) => {
    res.status(200).json('Server on Port 5000 and Database messages has been connected.');
});

routerMessage.post('/send-message', messController.sendMessage);
routerMessage.get('/my-messages/:username', messController.getMessages);
routerMessage.get('/my-messages', messController.getMessagesAll);
routerMessage.get('/get-message/:messageid', messController.getMessage);

module.exports = routerMessage;
