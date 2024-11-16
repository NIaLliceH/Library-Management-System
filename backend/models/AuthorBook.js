const mongoose = require('mongoose');

const authorBookSchema = new mongoose.Schema({
  ID_book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
  author: String,
});

module.exports = mongoose.model('AuthorBook', authorBookSchema);
