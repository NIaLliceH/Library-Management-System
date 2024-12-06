const mongoose = require('mongoose');

const holdTicketSchema = new mongoose.Schema({
  status: String,
  day_create: { type: Date, default: Date.now },   //sửa lại default
  day_expired: Date,
  quantity: Number,   //sửa
  cancelAt: { type: String, default: "Not yet"},
  cancelBy: { type: String, default: "Not yet"},
  ID_student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  ID_book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
});

module.exports = mongoose.model('HoldTicket', holdTicketSchema);
