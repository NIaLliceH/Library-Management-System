const express = require('express');
const router = express.Router();
const Book = require('../models/Book'); // Import the Book model
const CopyBook = require('../models/CopyBook');
// Get all books
router.get('/', async (req, res) => {
  try {
    const books = await Book.find({}).lean();
    for (const book of books) {
      book.copies = await CopyBook.find({ ID_book: book._id }, 'shell');
    }
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách sách', error });
  }
});

// Get a book by ID
router.get('/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id).lean();
    if (book) {
      book.copies = await CopyBook.find({ ID_book: book._id }, 'shell'); // Lấy thông tin shell từ CopyBook
      res.json(book);
    } else {
      res.status(404).json({ message: 'Không tìm thấy sách' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy thông tin sách', error });
  }
});
// POST route to add a new book
router.post('/', async (req, res) => {
  try {
    const { name, NoCopies, NoValidCopies, NoPages, AvgRate, Publisher, Description, imageUrl, copies } = req.body;
    const newBook = new Book({
      name,
      NoCopies,
      NoValidCopies,
      NoPages,
      AvgRate,
      Publisher,
      Description,
      imageUrl, 
    });
    //Create each CopyBook entry linked to this Book
    const savedBook = await newBook.save();
    if (copies && copies.length > 0) {
      const copyBooks = copies.map(copy => ({
        ID_book: savedBook._id,
        shell: copy.shell, 
        status: copy.status || "available", 
        publish_date: copy.publish_date || new Date().toISOString(), 
        edition: copy.edition || "1st edition", 
      }));
      const savedCopies = await CopyBook.insertMany(copyBooks);
      res.status(201).json({ book: savedBook, copies: savedCopies });
    } else {
      res.status(201).json({ book: savedBook, copies: [] });
    }
  } catch (error) {
    res.status(400).json({ message: 'Lỗi khi thêm thông tin sách', error });
  }
});
// rate book
router.post('/:id/rate', async (req, res) => {
  try {
    const { rating } = req.body;

    if (![1, 2, 3, 4, 5].includes(rating)) {
      return res.status(400).json({ message: 'Đánh giá không hợp lệ' });
    }

    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách đánh giá' });
    }
    if (rating === 1) book.Rate.one += 1;
    else if (rating === 2) book.Rate.two += 1;
    else if (rating === 3) book.Rate.three += 1;
    else if (rating === 4) book.Rate.four += 1;
    else if (rating === 5) book.Rate.five += 1;

    await book.save();
    res.status(200).json({ message: 'Đánh giá thành công', AvgRate: book.AvgRate });
  } catch (error) {
    res.status(500).json({ message: 'Đánh giá thất bại', error });
  }
});

module.exports = router;
