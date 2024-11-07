const express = require('express');
const router = express.Router();
const Book = require('../models/Book'); // Import the Book model
// Get all books
router.get('/', async (req, res) => {
  try {
    const books = await Book.find({});
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving books', error });
  }
});

// Get a book by ID
router.get('/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (book) {
      res.json(book);
    } else {
      res.status(404).json({ message: 'Book not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving book', error });
  }
});
// POST route to add a new book
router.post('/', async (req, res) => {
  try {
    const { name, NoCopies, NoValidCopies, NoPages, AvgRate, Publisher, Description } = req.body;

    const newBook = new Book({
      name,
      NoCopies,
      NoValidCopies,
      NoPages,
      AvgRate,
      Publisher,
      Description,
    });

    const savedBook = await newBook.save();
    res.status(201).json(savedBook);
  } catch (error) {
    res.status(400).json({ message: 'Error adding book', error });
  }
});

module.exports = router;
