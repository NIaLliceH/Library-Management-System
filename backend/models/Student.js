const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  MSSV: String,
  dob: String,
  faculty: String,
  NoWarning: String,
});

module.exports = mongoose.model('Student', studentSchema);
