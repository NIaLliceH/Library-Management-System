const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  ID_book: {type: mongoose.Schema.Types.ObjectId, ref: 'Book'},
  Category: String,
});

module.exports = mongoose.model('CategoryBook', categorySchema);
