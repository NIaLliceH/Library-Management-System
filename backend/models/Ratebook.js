const mongoose = require('mongoose');

const rateBookSchema = new mongoose.Schema({
  ID_stu: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  ID_Boo: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
  Rating: Number,   //sửa
});

module.exports = mongoose.model('RateBook', rateBookSchema);
