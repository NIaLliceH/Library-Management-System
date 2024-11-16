const mongoose = require('mongoose');

const borrowTicketSchema = new mongoose.Schema({
  status: String,
  borrow_day: Date,
  return_day: Date,
  no_day_left: String,
  ID_student: { type: mongoose.Schema.Types.ObjectId, ref: 'Student' },
  ID_copy: { type: mongoose.Schema.Types.ObjectId, ref: 'CopyBook' },
  ID_admin: { type: mongoose.Schema.Types.ObjectId, ref: 'Admin' },
});

module.exports = mongoose.model('BorrowTicket', borrowTicketSchema);
