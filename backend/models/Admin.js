const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
  job_description: String,
  ID: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Admin', adminSchema);
