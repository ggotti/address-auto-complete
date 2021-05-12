const sqlite3 = require('sqlite3');

const file = './address.db';

const headers = {
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET"
};

const db = new sqlite3.Database(file, sqlite3.OPEN_READONLY);

function addressLookup(db, address) {
    return new Promise(((resolve, reject) => {
        db.serialize(() => {
            db.all("SELECT at.ADDRESS_AS_TEXT, a.* FROM ADDRESS_TEXT at, ADDRESS a " +
                "WHERE at.ADDRESS_AS_TEXT LIKE ? AND a.ADDRESS_DETAIL_PID = at.ADDRESS_DETAIL_PID LIMIT 10", [
                `${address}%`
            ], function (err, rows) {
                if (err) {
                    reject(err)
                }
                resolve(rows);
            });
        })
    }))
}

exports.lambdaHandler = async (event, context) => {
    const searchTerm = event?.queryStringParameters?.search;

    if (!searchTerm || searchTerm === '' || `${searchTerm}`.length < 3) {
        return {
            'statusCode': 422,
            'body': {
                "errors": ["search query param was invalid"]
            }
        }
    }

    try {
        const rows = await addressLookup(db, searchTerm);
        const addresses = rows.map(row => Object.fromEntries(Object.entries(row).filter(([_, v]) => v != null)))
        return {
            'statusCode': 200,
            headers,
            'body': JSON.stringify({
                addresses
            })
        }
    } catch (err) {
        console.log(err);
        return {err};
    }
};
