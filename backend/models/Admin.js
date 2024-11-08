const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
  job_description: String,
});

module.exports = mongoose.model('Admin', adminSchema);
