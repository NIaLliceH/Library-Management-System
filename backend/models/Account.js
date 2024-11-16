const mongoose = require('mongoose');

const accountSchema = new mongoose.Schema({
    Password: String,
    Use_Role: String,
    Status: String,
    Email: String,
    
});

module.exports = mongoose.model('Account', accountSchema);
