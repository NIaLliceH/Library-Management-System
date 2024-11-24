const mongoose = require('mongoose');

const accountSchema = new mongoose.Schema({
    HashPassword: String,
    Use_Role: String,
    Status: String,
    Email: { type: String, unique: true },
});

module.exports = mongoose.model('Account', accountSchema);
