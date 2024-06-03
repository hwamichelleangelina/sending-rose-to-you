const Rose = require('../models/rose');

exports.sendRose = (req, res) => {
    const { sender, receiver, jumlahmawar, rosecolor } = req.body;

    Rose.sendRose({sender, receiver, jumlahmawar, rosecolor}, (err, rose) => {
        if (err) {
            res.status(500).json({message: 'Error while sending rose.'});
        }
        else {
            res.status(201).json({message: 'User successfully sent a rose.', rose});
        }
    });
}

exports.getRoses = (req, res) => {
    const username = req.params.username;

    Rose.getRoses(username, (err, roses) => {
        if (err) {
            res.status(500).json({ message: 'Failed to get roses.' });
        } else {
            if (roses.length > 0) {
                res.status(200).json({ message: 'Successfully retrieved roses.', roses });
            } else {
                res.status(404).json({ message: 'No roses.' });
            }
        }
    });
};

exports.getRose = (req, res) => {
    const roseid = req.params.roseid;

    Rose.getRose(roseid, (err, rose) => {
        if (err) {
            res.status(500).json({ message: 'Failed to get rose.' });
        } else {
            if (rose.length > 0) {
                res.status(200).json({ message: 'Successfully retrieved rose.', rose });
            } else {
                res.status(404).json({ message: 'No rose found.' });
            }
        }
    });
};