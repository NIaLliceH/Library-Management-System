const mongoose = require('mongoose');

const bookSchema = new mongoose.Schema({
  name: String,
  NoValidCopies: String,
  NoPages: { type: Number, min: 1 }, 
  Publisher: String,
  Description: String,
  imageUrl: String,
  Rate: {
    one: { type: Number, default: 0 },
    two: { type: Number, default: 0 },
    three: { type: Number, default: 0 },
    four: { type: Number, default: 0 },
    five: { type: Number, default: 0 },
  },
  datePublish: { type: Date, default: Date.now },
  edition: String,
});

// Virtual for calculating NoCopies based on CopyBook status
bookSchema.virtual('NoCopies').get(async function () {
  const CopyBook = mongoose.model('CopyBook');
  const totalCopies = await CopyBook.countDocuments({ ID_book: this._id });
  const borrowedOrReservedCopies = await CopyBook.countDocuments({ ID_book: this._id, status: { $in: ['borrowed', 'reserved'] } });
  return totalCopies - borrowedOrReservedCopies;
});

// Virtual for calculating the average rating
bookSchema.virtual('AvgRate').get(function () {
  const totalRatings = this.Rate.one + this.Rate.two + this.Rate.three + this.Rate.four + this.Rate.five;
  if (totalRatings === 0) return 0;

  const avgRate = (
    this.Rate.one * 1 +
    this.Rate.two * 2 +
    this.Rate.three * 3 +
    this.Rate.four * 4 +
    this.Rate.five * 5
  ) / totalRatings;

  return avgRate.toFixed(1);
});

bookSchema.set('toJSON', { virtuals: true });
bookSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Book', bookSchema);