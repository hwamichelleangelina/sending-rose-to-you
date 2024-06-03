const mysql = require('mysql');

const db_hosting = mysql.createConnection({
    host: 'sql12.freemysqlhosting.net',
    user: 'sql12711382',
    password: ' Ltj2i51Dn6',
    database: 'sql12711382'
});

db_hosting.connect((err) => {
    if (err) throw err;
    console.log('Connected to database Roses');
});

module.exports = db;
