const db = require('../config/db');

class Rose {
    static sendRose(roseData, callback) {
        if (!roseData || Object.keys(roseData).length === 0) {
            callback('Rose data is empty', null);
            return;
        }
    
        const { sender, receiver, jumlahmawar, rosecolor } = roseData;
        const createRoseQuery = `
        INSERT INTO roses (sender, senderid, receiver, receiverid, jumlahmawar, rosecolor)
        VALUES (?, (SELECT userid FROM users WHERE username = ?), ?, (SELECT userid FROM users WHERE username = ?), ?, ?);
        `;
    
        db.query(createRoseQuery, [
            sender, sender, receiver, receiver, jumlahmawar, rosecolor
        ], (err, result) => {
            if (err) {
                console.error('Error creating rose:', err);
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }

    static getRoses(username, callback) {
        const getRosesQuery = 'SELECT *, CONVERT_TZ(created_at, \'+00:00\', \'+07:00\') AS timestamp FROM roses WHERE receiver = ?;';
        db.query(getRosesQuery, [username], (err, result) => {
            if (err) {
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }

    static getRose(roseid, callback) {
        const getRoseQuery = 'SELECT * FROM roses WHERE roseid = ?;';
        db.query(getRoseQuery, [roseid], (err, result) => {
            if (err) {
                callback(err, null);
            } else {
                callback(null, result);
            }
        });
    }
};

module.exports = Rose;
