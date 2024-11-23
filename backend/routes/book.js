const express = require('express');
const router = express.Router();
const Book = require('../models/Book'); // Import the Book model
const CopyBook = require('../models/CopyBook');
const CategoryBook = require('../models/CategoryBook');
const AuthorBook = require('../models/AuthorBook');

// Get all books
router.get('/', async (req, res) => {
  try {
    const books = await Book.find({}).lean();
    for (const book of books) {
      book.copies = await CopyBook.find({ ID_book: book._id });
      book.categories = await CategoryBook.find({ ID_book: book._id }, 'category');
      book.authors = await AuthorBook.find({ ID_book: book._id }, 'author');
    }
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách sách', error });
  }
});
// Lấy tất cả category
router.get('/categories', async (req, res) => {
  try {
    const categories = await CategoryBook.find({}).distinct('category');
    res.json({ categories });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách categories', error });
  }
});
// Lấy sách theo category
router.get('/category/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const categoryBooks = await CategoryBook.find({ category }).populate('ID_book');
    if (!categoryBooks.length) {
      return res.status(404).json({ message: 'Không tìm thấy sách trong category này' });
    }

    const books = categoryBooks.map(cb => cb.ID_book);
    res.status(200).json(books);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách theo category', error });
  }
});

// Tìm kiếm sách theo tên
router.get('/search', async (req, res) => {
  try {
    const { name } = req.query;

    if (!name || name.trim() === '') {
      return res.status(400).json({ message: 'Vui lòng cung cấp từ khóa để tìm kiếm' });
    }

    const books = await Book.find({ name: { $regex: new RegExp(name, 'i') } }).lean();

    if (books.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy sách phù hợp với từ khóa' });
    }

    res.status(200).json(books);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi tìm kiếm sách', error });
  }
});

// Lấy 5 sách mới nhất
router.get('/newest', async (req, res) => {
  try {
    const newestBooks = await Book.find({})
      .sort({ datePublish: -1 })
      .limit(5);
    res.json(newestBooks);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách mới nhất', error });
  }
});

// Lấy 5 sách top rate
router.get('/top-rated', async (req, res) => {
  try {
    const books = await Book.find({}).lean(); // Dùng lean() để tối ưu hóa hiệu suất

    // Tính toán điểm đánh giá trung bình
    books.forEach(book => {
      const totalRatings = book.Rate.one + book.Rate.two + book.Rate.three + book.Rate.four + book.Rate.five;
      const avgRate = totalRatings
        ? (book.Rate.one * 1 + book.Rate.two * 2 + book.Rate.three * 3 + book.Rate.four * 4 + book.Rate.five * 5) / totalRatings
        : 0;
      book.AvgRate = avgRate.toFixed(1);
    });

    // Sắp xếp và chọn 5 sách có đánh giá cao nhất
    const topRatedBooks = books
      .sort((a, b) => b.AvgRate - a.AvgRate)
      .slice(0, 5)
      .map(book => ({
        _id: book._id,
        name: book.name,
        AvgRate: book.AvgRate,
        imageUrl: book.imageUrl, // Bao gồm URL ảnh
      }));

    res.json(topRatedBooks);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách có đánh giá cao nhất', error });
  }
});
// Thêm category
router.post('/:id/category', async (req, res) => {
  try {
    const { id } = req.params;
    const { category } = req.body;

    if (!category || category.trim() === '') {
      return res.status(400).json({ message: 'Vui lòng cung cấp tên category hợp lệ' });
    }

    const bookExists = await Book.findById(id);
    if (!bookExists) {
      return res.status(404).json({ message: 'Không tìm thấy sách với ID đã cung cấp' });
    }

    const newCategory = new CategoryBook({
      ID_book: id,
      category: category.trim(),
    });

    await newCategory.save();

    res.status(201).json({ message: 'Thêm category thành công', category: newCategory });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi thêm category', error });
  }
});

// Get a book by ID
router.get('/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id).lean();
    if (book) {
      const copies = await CopyBook.find({ ID_book: book._id });

      // Thêm trạng thái canBorrow
      book.copies = copies.map(copy => ({
        ...copy.toObject(),
        canBorrow: copy.status === "available" ? 1 : 0 // Kiểm tra trạng thái
      }));

      book.categories = await CategoryBook.find({ ID_book: book._id }, 'category');
      book.authors = await AuthorBook.find({ ID_book: book._id }, 'author');

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
    const {
      name,
      NoCopies,
      NoValidCopies,
      NoPages,
      AvgRate,
      Publisher,
      Description,
      imageUrl,
      copies,
      categories // Thêm danh sách category
    } = req.body;

    // Tạo một sách mới
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

    // Lưu sách vào cơ sở dữ liệu
    const savedBook = await newBook.save();

    // Thêm thông tin CopyBook nếu có
    if (copies && copies.length > 0) {
      const copyBooks = copies.map(copy => ({
        ID_book: savedBook._id,
        shell: copy.shell,
        status: copy.status || "available",
        publish_date: copy.publish_date || new Date().toISOString(),
        edition: copy.edition || "1st edition",
      }));
      await CopyBook.insertMany(copyBooks);
    }

    // Thêm category vào CategoryBook nếu có
    if (categories && categories.length > 0) {
      const categoryBooks = categories.map(category => ({
        ID_book: savedBook._id,
        category: category.trim(),
      }));
      await CategoryBook.insertMany(categoryBooks);
    }

    res.status(201).json({ message: 'Thêm sách thành công', book: savedBook });
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



// Xóa sách theo ID
router.delete('/:id', async (req, res) => {
  try {
    const bookId = req.params.id;

    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách để xóa' });
    }

    await CopyBook.deleteMany({ ID_book: bookId });
    await Book.findByIdAndDelete(bookId);
    res.status(200).json({ message: 'Xóa sách và các bản sao liên quan thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi xóa sách', error });
  }
});

// Cập nhật thông tin sách theo ID
router.put('/:id', async (req, res) => {
  try {
    const bookId = req.params.id;
    const { name, NoPages, Publisher, Description, imageUrl, copies } = req.body;

    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách để cập nhật' });
    }

    if (name) book.name = name;
    if (NoPages) book.NoPages = NoPages;
    if (Publisher) book.Publisher = Publisher;
    if (Description) book.Description = Description;
    if (imageUrl) book.imageUrl = imageUrl;

    await book.save();

    if (copies && copies.length > 0) {
      for (const copy of copies) {
        if (copy._id) {
          await CopyBook.findByIdAndUpdate(copy._id, {
            shell: copy.shell,
            status: copy.status,
            publish_date: copy.publish_date,
            edition: copy.edition,
          });
        } else {
          const newCopy = new CopyBook({
            ID_book: bookId,
            shell: copy.shell,
            status: copy.status || "available",
            publish_date: copy.publish_date || new Date().toISOString(),
            edition: copy.edition || "1st edition",
          });
          await newCopy.save();
        }
      }
    }

    res.status(200).json({ message: 'Cập nhật sách thành công', book });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật sách', error });
  }
});

module.exports = router;
