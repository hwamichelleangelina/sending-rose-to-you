const Message = require('../models/message');

exports.sendMessage = (req, res) => {
    const { sender, receiver, message } = req.body;

    Message.sendMessage({sender, receiver, message}, (err, message) => {
        if (err) {
            res.status(500).json({message: 'Error while sending message.'});
        }
        else {
            res.status(201).json({message: 'User successfully sent a message.', message});
        }
    });
}

exports.getMessages = (req, res) => {
    const username = req.params.username;

    Message.getMessages(username, (err, messages) => {
        if (err) {
            res.status(500).json({ message: 'Failed to get messages.' });
        } else {
            if (messages.length > 0) {
                res.status(200).json({ message: 'Successfully retrieved messages.', messages });
            } else {
                res.status(404).json({ message: 'No messages.' });
            }
        }
    });
};

exports.getMessagesAll = (req, res) => {
    Message.getMessagesAll((err, messages) => {
        if (err) {
            res.status(500).json({ message: 'Failed to get messages.' });
        } else {
            if (messages.length > 0) {
                res.status(200).json({ message: 'Successfully retrieved messages.', messages });
            } else {
                res.status(404).json({ message: 'No messages.' });
            }
        }
    });
};

exports.getMessage = (req, res) => {
    const messageid = req.params.messageid;

    Message.getMessage(messageid, (err, message) => {
        if (err) {
            res.status(500).json({ message: 'Failed to get message.' });
        } else {
            if (message.length > 0) {
                res.status(200).json({ message: 'Successfully retrieved message.', message });
            } else {
                res.status(404).json({ message: 'No message found.' });
            }
        }
    });
};