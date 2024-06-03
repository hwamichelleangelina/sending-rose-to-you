const mysql = require('mysql');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'supervise',
    database: 'roses'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to database Roses');
});

module.exports = db;
