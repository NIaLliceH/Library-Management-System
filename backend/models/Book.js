// models/Book.js
const mongoose = require('mongoose');

const bookSchema = new mongoose.Schema({
  name: String,
  NoCopies: String,
  NoValidCopies: String,
  NoPages: String,
  AvgRate: String,
  Publisher: String,
  Description: String,
});

module.exports = mongoose.model('Book', bookSchema);
