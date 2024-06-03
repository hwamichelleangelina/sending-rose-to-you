const User = require('../models/user');
const jwt = require('jsonwebtoken');


exports.register = (req, res) => {
    const { name, username, password } = req.body;

    User.register({name, username, password}, (err, users) => {
        if (err) {
            res.status(500).json({message: 'Error while registering user.', err});
        }
        else {
            res.status(201).json({message: 'User successfully registered, please continue login.', users});
        }
    });
}

exports.login = (req, res) => {
    const { username, password } = req.body;

    User.login(username, password, (err, user) => {
        if (err) return res.status(500).send(err);
        if (!user) return res.status(401).send('Invalid credentials');
        const token = jwt.sign({ userid: user.userid, username: username }, 'your_jwt_secret');
        res.status(200).json({ token });
    });
};