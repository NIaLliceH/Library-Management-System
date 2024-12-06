const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  ID_book: {type: mongoose.Schema.Types.ObjectId, ref: 'Book'},
  category: String,
});

module.exports = mongoose.model('CategoryBook', categorySchema);
