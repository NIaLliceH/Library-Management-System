const mongoose = require('mongoose');

const borrowTicketSchema = new mongoose.Schema({
  ID_book: {type: mongoose.Schema.Types.ObjectId, ref: 'Book'},
  Category: String,
});

module.exports = mongoose.model('BorrowTicket', borrowTicketSchema);
