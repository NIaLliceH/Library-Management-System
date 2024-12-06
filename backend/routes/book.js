const express = require('express');
const router = express.Router();
const Book = require('../models/Book'); // Import the Book model
const CopyBook = require('../models/CopyBook');
const AuthorBook = require('../models/AuthorBook');

// Get all books
router.get('/', async (req, res) => {
  try {
    const books = await Book.find({}).lean();
    const result =[];
    for (const book of books) {
      book.copies = await CopyBook.find({ ID_book: book._id });
      authors = await AuthorBook.find({ ID_book: book._id }, 'author');
      // Tính toán NoCopies
      const totalCopies = await CopyBook.countDocuments({ ID_book: book._id });
      const borrowedOrReservedCopies = await CopyBook.countDocuments({ ID_book: book._id, status: { $in: ['borrowed', 'reserved'] } });
      const NoAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        author: authors.map(a => a.author),
        edition: book.edition,
        NoAvaiCopies,
      });
    }

    res.json({
      message: "Success",
      data: result,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách sách', error });
  }
});
// Lấy tất cả category
router.get('/categories', async (req, res) => {
  try {
    const categories = await Book.distinct('category');
    res.json({ 
      message: "Success",
      data:categories,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách categories', error });
  }
});
// Lấy sách theo category
router.get('/category/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const books = await Book.find({ category }).lean();
    
    if (!books.length) {
      return res.status(404).json({ message: 'Không tìm thấy sách trong category này' });
    }
    const result =[];
    for (const book of books) {
      book.copies = await CopyBook.find({ ID_book: book._id });
      authors = await AuthorBook.find({ ID_book: book._id }, 'author');
      // Tính toán NoCopies
      const totalCopies = await CopyBook.countDocuments({ ID_book: book._id });
      const borrowedOrReservedCopies = await CopyBook.countDocuments({ ID_book: book._id, status: { $in: ['borrowed', 'reserved'] } });
      const NoAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({ 
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        author: authors.map(a => a.author),
        edition: book.edition,
        NoAvaiCopies,
      });
    }
    res.json({
      message: "Success",
      data: result,
    });
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

    const result =[];
    for (const book of books) {
      book.copies = await CopyBook.find({ ID_book: book._id });
      authors = await AuthorBook.find({ ID_book: book._id }, 'author');
      // Tính toán NoCopies
      const totalCopies = await CopyBook.countDocuments({ ID_book: book._id });
      const borrowedOrReservedCopies = await CopyBook.countDocuments({ ID_book: book._id, status: { $in: ['borrowed', 'reserved'] } });
      const NoAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({ 
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        author: authors.map(a => a.author),
        edition: book.edition,
        NoAvaiCopies,
      });
    }
    res.json({
      message: "Success",
      data: result,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi tìm kiếm sách', error });
  }
});

// Lấy 5 sách mới nhất
router.get('/newest', async (req, res) => {
  try {
    const books = await Book.find({})
      .sort({ datePublish: -1 })
      .limit(5);
      const result =[];
      for (const book of books) {
        book.copies = await CopyBook.find({ ID_book: book._id });
        authors = await AuthorBook.find({ ID_book: book._id }, 'author');
        // Tính toán NoCopies
        const totalCopies = await CopyBook.countDocuments({ ID_book: book._id });
        const borrowedOrReservedCopies = await CopyBook.countDocuments({ ID_book: book._id, status: { $in: ['borrowed', 'reserved'] } });
        const NoAvaiCopies = totalCopies - borrowedOrReservedCopies;
        
        result.push({ 
          bookId: book._id,
          name: book.name,
          imageUrl: book.imageUrl,
          category: book.category,
          author: authors.map(a => a.author),
          edition: book.edition,
          NoAvaiCopies,
        });
      }
      res.json({
        message: "Success",
        data: result,
      });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách mới nhất', error });
  }
});

// Lấy 5 sách top rate
router.get('/top-rated', async (req, res) => {
  try {
    const books = await Book.find({}).lean(); // Dùng lean() để tối ưu hóa hiệu suất

    // Tính toán điểm đánh giá trung bình
    const booksWithAvgRate = books.map(book => {
      const totalRatings = book.Rate.one + book.Rate.two + book.Rate.three + book.Rate.four + book.Rate.five;
      const avgRate = totalRatings
        ? (book.Rate.one * 1 + book.Rate.two * 2 + book.Rate.three * 3 + book.Rate.four * 4 + book.Rate.five * 5) / totalRatings
        : 0;

      return {
        ...book,
        AvgRate: avgRate.toFixed(1),
      };
    });


    // Sắp xếp và chọn 5 sách có đánh giá cao nhất
    const topRatedBooks = books
      .sort((a, b) => b.AvgRate - a.AvgRate)
      .slice(0, 5)
      .map(book => ({
        _id: book._id,
        name: book.name,
        avgRating: book.avgRate ? book.avgRate : null,
        imageUrl: book.imageUrl, 
      }));

    res.json({
      message: "Success",
      data:topRatedBooks,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách có đánh giá cao nhất', error });
  }
});
// Cập nhật sách
router.put('/:id', async (req, res) => {
  try {
    const bookId = req.params.id;
    const updates = req.body; 

    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách để cập nhật' });
    }
    Object.keys(updates).forEach(key => {
      book[key] = updates[key]; 
    });

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

    res.status(200).json({ message: 'Cập nhật sách thành công', data: book });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật sách', error });
  }
});
// Get a book by ID
router.get('/:id', async (req, res) => {
  try {
    // Tìm sách theo ID
    const { id: bookId } = req.params; // ID của sách
    const { userID } = req.query;
    const book = await Book.findById(bookId).lean();
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách' });
    }
    if (userID) {
      const studentExists = await Student.findOne({ ID: userID }).lean();
      if (!studentExists) {
        return res.status(404).json({ message: 'Không tìm thấy userID' });
      }
    }
     // Tìm các bản sao của sách
     const copies = await CopyBook.find({ ID_book: book._id }).lean();

     // Tính tổng số bản sao và số bản có thể mượn
     const totalCopies = copies.length;
     const availableCopies = copies.filter(copy => copy.status === "available").length;
    // Tìm các tác giả của sách
    const authors = await AuthorBook.find({ ID_book: book._id }, 'author').lean();
    // Kiểm tra logic canHold
    let canHold = true;
    if (userID) {
      const activeBorrowTicket = await BorrowTicket.findOne({
        ID_student: userID,
        ID_copy: { $in: copies.map(copy => copy._id) },
        status: "borrowing",
      });

      const canceledHoldTicket = await HoldTicket.findOne({
        ID_student: userID,
        ID_book: book._id,
        status: "cancle",
      });

      if (activeBorrowTicket || canceledHoldTicket) {
        canHold = !!(activeBorrowTicket && canceledHoldTicket);
      }
    }
    // Chuẩn bị đối tượng phản hồi
    const response = {
      bookId: book._id,
      name: book.name,
      authors: authors.length > 0 ? authors.map(a => a.author) : null, // Danh sách tác giả
      category: book.category,
      publisher: book.Publisher || null,
      noCopies: totalCopies,
      noAvaiCopies: availableCopies,
      noPages: book.NoPages,
      avgRating: book.avgRate ? book.avgRate : null,
      description: book.Description || null,
      edition: book.edition ? book.edition : null,
      publishDate: book.datePublish ? book.datePublish : null,
      canHold: canHold ? 1 : 0,
    };

    // Trả về JSON
    return res.json({
      message: "Success",
      data:response,
    });
  } catch (error) {
    // Xử lý lỗi
    return res.status(500).json({ message: 'Lỗi khi lấy thông tin sách', error });
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
      category 
    } = req.body;

    const newBook = new Book({
      name,
      NoCopies,
      NoValidCopies,
      NoPages,
      AvgRate,
      Publisher,
      Description,
      imageUrl,
      category, 
    });

    const savedBook = await newBook.save();

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
// Xóa một bản sao cụ thể
router.delete('/copies/:id', async (req, res) => {
  try {
    const copyId = req.params.id;

    const copy = await CopyBook.findById(copyId);
    if (!copy) {
      return res.status(404).json({ message: 'Không tìm thấy bản sao để xóa' });
    }

    await CopyBook.findByIdAndDelete(copyId);

    res.status(200).json({ message: 'Xóa bản sao thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi xóa bản sao', error });
  }
});

module.exports = router;
