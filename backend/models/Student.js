const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  MSSV: { type: String, unique: true, required: true },
  dob: String,
  faculty: String,
  NoWarning: Number,
  ID: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
});

module.exports = mongoose.model('Student', studentSchema);
