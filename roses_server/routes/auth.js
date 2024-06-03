const express = require('express');
const routerUser = express.Router();
const authController = require('../controllers/auth');

routerUser.get('/', (req, res) => {
    res.status(200).json('Server on Port 5000 and Database has been connected.');
});

routerUser.post('/register', authController.register);
routerUser.post('/login', authController.login);

module.exports = routerUser;
