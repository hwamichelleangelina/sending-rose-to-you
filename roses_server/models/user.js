const db = require('../config/db');
const bcrypt = require('bcryptjs');

class User {
    static register(userData, callback) {
        const { name, username, password } = userData;
        bcrypt.hash(password, 10, (err, hash) => {
            if (err) {
                callback(err, null);
            }
            else {
                const query = 'INSERT INTO users(name, username, password) values (?, ?, ?);';
                db.query(query, [name, username, hash], (err, result) => {
                    if (err) {
                        callback(err, null);
                    }
                    else {
                        callback(null, result);
                    }
                });
            }
        });
    }

    static login(username, password, callback) {
        const query = 'SELECT * FROM users WHERE username = ?;';
        db.query(query, [username], (err, result) => {
            if (err) {
                callback(err, null);
            }
            else if (result.length > 0) {
                const user = result[0];
                bcrypt.compare(password, user.password, (err, result) => {
                    if (result) {
                        callback(null, user);
                    }
                    else {
                        callback(null, null);
                    }
                });
            }
            else {
                callback(null, null);
            }
        });
    }
};

module.exports = User;
