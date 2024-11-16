const mongoose = require('mongoose');

const holdTicketSchema = new mongoose.Schema({
  status: String,
  day_create: Date,
  day_expired: Date,
  quantity: String,
  ID_student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  ID_book: { type: mongoose.Schema.Types.ObjectId, ref: 'Book' },
});

module.exports = mongoose.model('HoldTicket', holdTicketSchema);
