const db = require('../config/db');

class Message {
    static sendMessage(messageData, callback) {
        if (!messageData || Object.keys(messageData).length === 0) {
            callback('Message data is empty', null);
            return;
        }
    
        const { sender, receiver, message } = messageData;
        const createMessageQuery = `
        INSERT INTO messages (sender, senderid, receiver, receiverid, message)
        VALUES (?, (SELECT userid FROM users WHERE username = ?), ?, (SELECT userid FROM users WHERE username = ?), ?);
        `;
    
        db.query(createMessageQuery, [
            sender, sender, receiver, receiver, message
        ], (err, result) => {
            if (err) {
                console.error('Error creating message:', err);
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }

    static getMessages(username, callback) {
        const getMessagesQuery = 'SELECT *, CONVERT_TZ(created_at, \'+00:00\', \'+07:00\') AS timestamp FROM messages WHERE receiver = ?;';
        db.query(getMessagesQuery, [username], (err, result) => {
            if (err) {
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }

    static getMessagesAll(callback) {
        const getMessagesQuery = 'SELECT * FROM messages;';
        db.query(getMessagesQuery, (err, result) => {
            if (err) {
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }

    static getMessage(messageid, callback) {
        const getMessageQuery = 'SELECT *, CONVERT_TZ(created_at, \'+00:00\', \'+07:00\') AS timestamp FROM messages WHERE messageid = ?;';
        db.query(getMessageQuery, [messageid], (err, result) => {
            if (err) {
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }
};

module.exports = Message;
