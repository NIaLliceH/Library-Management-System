const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: String,
  gender: String,
  address: String,
  avatar: String,
  join_date: String,
  email: String,
});

module.exports = mongoose.model('User', userSchema);
