const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  MSSV: String,
  dob: String,
  faculty: String,
  NoWarning: String,
  ID: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Student', studentSchema);
