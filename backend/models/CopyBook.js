const mongoose = require('mongoose');

const copyBookSchema = new mongoose.Schema({
  ID_book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
  shell: String,
  status: Number,   //value = 0/1
  
});

module.exports = mongoose.model('CopyBook', copyBookSchema);
