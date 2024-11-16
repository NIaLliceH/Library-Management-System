const mongoose = require('mongoose');

const copyBookSchema = new mongoose.Schema({
  ID_book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
  shell: String,
  status: String,
  publish_date: Date,
  edition: String,
});

module.exports = mongoose.model('CopyBook', copyBookSchema);
