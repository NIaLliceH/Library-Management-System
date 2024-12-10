const express = require('express');
const router = express.Router();
const Book = require('../models/Book'); // Import the Book model
const CopyBook = require('../models/CopyBook');
const AuthorBook = require('../models/AuthorBook');
const borrowTicket = require('../models/BorrowTicket');
const HoldTicket = require('../models/HoldTicket');
const Student = require('../models/Student')

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
      const noAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        authors: authors.map(a => a.author),
        edition: book.edition,
        noAvaiCopies,
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
      const noAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({ 
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        authors: authors.map(a => a.author),
        edition: book.edition,
        noAvaiCopies,
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
      const noAvaiCopies = totalCopies - borrowedOrReservedCopies;
      
      result.push({ 
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        category: book.category,
        authors: authors.map(a => a.author),
        edition: book.edition,
        noAvaiCopies,
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
        const noAvaiCopies = totalCopies - borrowedOrReservedCopies;
        
        result.push({ 
          bookId: book._id,
          name: book.name,
          imageUrl: book.imageUrl,
          category: book.category,
          authors: authors.map(a => a.author),
          edition: book.edition,
          noAvaiCopies,
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
    const topRatedBooks = booksWithAvgRate
      .sort((a, b) => b.AvgRate - a.AvgRate)
      .slice(0, 5);

    // Thêm thông tin về số bản sao có sẵn và tác giả
    const topRatedBooksWithDetails = await Promise.all(
      topRatedBooks.map(async book => {
        const [authors, copies] = await Promise.all([
          AuthorBook.find({ ID_book: book._id }, 'author').lean(),
          CopyBook.find({ ID_book: book._id, status: 'available' }).lean()
        ]);

        const noAvaiCopies = copies.length;

        return {
          bookId: book._id,
          name: book.name,
          avgRating: book.AvgRate,
          imageUrl: book.imageUrl || null,
          category: book.category,
          authors: authors.map(a => a.author),
          edition: book.edition || null,
          noAvaiCopies,
        };
      })
    );

    res.json({
      message: "Success",
      data: topRatedBooksWithDetails,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy sách có đánh giá cao nhất', error });
  }
});
// cập nhật copies
router.put('/:bookId/copies/:copyId', async (req, res) => {
  try {
    const { bookId, copyId } = req.params; // Lấy bookId và copyId từ URL
    const { shell, status } = req.body; // Dữ liệu cần cập nhật

    // Kiểm tra xem bản sao có tồn tại không
    const copy = await CopyBook.findOne({ _id: copyId, ID_book: bookId });
    if (!copy) {
      return res.status(404).json({ message: 'Không tìm thấy bản sao để cập nhật' });
    }

    // Cập nhật các trường nếu có trong body
    if (shell !== undefined) copy.shell = shell;
    if (status !== undefined) copy.status = status;

    // Lưu bản sao sau khi cập nhật
    const updatedCopy = await copy.save();

    res.status(200).json({
      message: 'Cập nhật bản sao thành công',
      data: updatedCopy,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật bản sao', error });
  }
});

// Cập nhật sách
router.put('/:id', async (req, res) => {
  try {
    const bookId = req.params.id;
    const { copies,authors, ...updates } = req.body;

    // Tìm sách theo ID
    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách để cập nhật' });
    }

    // Cập nhật thông tin sách
    Object.keys(updates).forEach((key) => {
      if (updates[key] !== undefined) {
        book[key] = updates[key];
      }
    });
    await book.save();

    // Xử lý cập nhật bản sao
    let updatedCopies = [];
    if (copies && Array.isArray(copies)) {
      const bulkOps = copies.map((copy) => {
        if (copy._id) {
          // Cập nhật bản sao đã tồn tại
          return {
            updateOne: {
              filter: { copyID: copy._id, ID_book: bookId },
              update: {
                shell: copy.shell,
                status: copy.status,
              },
            },
          };
        } else {
          // Tạo bản sao mới
          return {
            insertOne: {
              document: {
                ID_book: bookId,
                shell: copy.shell || "Default Shell",
                status: copy.status || "available",
              },
            },
          };
        }
      });
      
      const bulkWriteResult = await CopyBook.bulkWrite(bulkOps);
      updatedCopies = {
        modifiedCount: bulkWriteResult.modifiedCount || 0,
        insertedCount: bulkWriteResult.insertedCount || 0,
      };
    }
    let updatedAuthors = [];
    if (authors && Array.isArray(authors)) {
      await AuthorBook.deleteMany({ ID_book: bookId });
      const authorDocs = authors.map((author) => ({
        ID_book: bookId,
        author,
      }));
      updatedAuthors = await AuthorBook.insertMany(authorDocs);
    }
    res.status(200).json({
      message: 'Cập nhật sách thành công',
      data: {
        book,
        updatedCopies,
        updatedAuthors,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật sách', error });
  }
});

// Get a book by ID
router.get('/:id', async (req, res) => {
    try {
      const { id } = req.params; // ID của sách
      const { userID } = req.query;
  
      // Tìm sách theo ID
      const book = await Book.findById(id).lean();
      if (!book) {
        return res.status(404).json({ message: 'Không tìm thấy sách' });
      }
  
      // Nếu có userID, kiểm tra sự tồn tại của user
      if (userID) {
        const studentExists = await Student.findOne({ ID: userID }).lean();
        if (!studentExists) {
          return res.status(404).json({ message: 'Không tìm thấy userID' });
        }
      }
  
      // Tìm các bản sao của sách
      const copies = await CopyBook.find({ ID_book: book._id }).lean();
  
      // Tính tổng số bản sao và số bản sao có thể mượn
      const totalCopies = copies.length;
      const availableCopies = copies.filter(copy => copy.status === "available").length;
  
      // Tìm các tác giả của sách
      const authors = await AuthorBook.find({ ID_book: book._id }, 'author').lean();
  
      // Kiểm tra logic canHold
      let canHold = true;
  
      if (userID) {
        // Kiểm tra BorrowTicket với status = 'borrowing'
        const activeBorrowTicket = await borrowTicket.findOne({
          ID_student: userID,
          ID_copy: { $in: copies.map(copy => copy._id) },
          status: "borrowing",
        });
  
        // Kiểm tra HoldTicket với status = 'valid'
        const validHoldTicket = await HoldTicket.findOne({
          ID_student: userID,
          ID_book: book._id,
          status: "valid",
        });
  
        // Đặt canHold thành false nếu bất kỳ điều kiện nào không thỏa mãn
        if (activeBorrowTicket || availableCopies <= 0 || validHoldTicket) {
          canHold = false;
        }
      }
  
      // Chuẩn bị đối tượng phản hồi
      const response = {
        bookId: book._id,
        name: book.name,
        imageUrl: book.imageUrl,
        authors: authors.map(a => a.author), // Danh sách tác giả
        category: book.category || null,
        publisher: book.Publisher || null,
        noCopies: totalCopies,
        noAvaiCopies: availableCopies,
        noPages: book.NoPages || null,
        avgRating: book.avgRate || null,
        description: book.Description || null,
        edition: book.edition || null,
        publishDate: book.datePublish || null,
        canHold: canHold ? 1 : 0,
        copies: copies.map(copy => ({
          copyId: copy._id,
          shell: copy.shell || null,
          status: copy.status || null,
        })),
      };
  
      // Trả về JSON
      return res.json({
        message: "Success",
        data: response,
      });
    } catch (error) {
      // Xử lý lỗi
      console.error(error); // Ghi log lỗi để kiểm tra
      return res.status(500).json({ message: 'Lỗi khi lấy thông tin sách', error: error.message });
    }
  });


// POST route to add a new book
// POST route to add a new book
router.post('/', async (req, res) => {
  try {
    const {
      name,
      noValidCopies,
      noPages,
      publisher,
      description,
      imageUrl,
      copies,
      category,
      authors,
    } = req.body;

    // Kiểm tra các trường bắt buộc
    if (!name || !category) {
      return res.status(400).json({ message: 'Vui lòng cung cấp tên sách và thể loại.' });
    }

    // Tạo sách mới
    const newBook = new Book({
      name,
      noValidCopies: noValidCopies || 0,
      nameoPages: noPages || 0,
      publisher: publisher || "Unknown Publisher",
      description: description || "No description available",
      imageUrl: imageUrl || null,
      category,
    });

    // Lưu thông tin sách
    const savedBook = await newBook.save();

    // Xử lý danh sách bản sao (copies) nếu có
    let savedCopies = [];
    if (copies && Array.isArray(copies)) {
      const copyBooks = copies.map(copy => ({
        ID_book: savedBook._id,
        shell: copy.shell || "Default Shell",
        status: copy.status || "available",
      }));
      savedCopies = await CopyBook.insertMany(copyBooks);
    }

    // Xử lý danh sách tác giả (authors) nếu có
    let savedAuthors = [];
    if (authors && Array.isArray(authors)) {
      const authorDocs = authors.map(author => ({
        ID_book: savedBook._id,
        author,
      }));
      savedAuthors = await AuthorBook.insertMany(authorDocs);
    }

    res.status(201).json({
      message: 'Success',
      data: {
        book: savedBook,
        copies: savedCopies,
        authors: savedAuthors,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi thêm thông tin sách', error });
  }
});

// rate book
router.post('/:id/rate', async (req, res) => {
  try {
    const { rating, userID, borrowID } = req.body;

    if (![1, 2, 3, 4, 5].includes(rating)) {
      return res.status(400).json({ message: 'Đánh giá không hợp lệ' });
    }

    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách đánh giá' });
    }

    // Kiểm tra sinh viên đã đánh giá chưa
    const existingRating = await RateBook.findOne({ ID_stu, ID_Boo: req.params.id });
    if (existingRating) {
      return res.status(400).json({ message: 'Sinh viên đã đánh giá sách này rồi' });
    }

    // Kiểm tra BorrowTicket tồn tại và cập nhật trạng thái rated
    const borrowTicket = await BorrowTicket.findById(borrowID);
    if (!borrowTicket) {
      return res.status(404).json({ message: 'Không tìm thấy phiếu mượn' });
    }
    if (borrowTicket.rated === '1') {
      return res.status(400).json({ message: 'Phiếu mượn này đã được đánh giá' });
    }

    borrowTicket.rated = '1'; // Chuyển trạng thái rated thành '1'
    await borrowTicket.save();
    const newRate = new RateBook({
      ID_stu: userID,
      ID_Boo: req.params.id,
      Rating: rating,
    });
    await newRate.save();

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
90

router.delete('/:id/copies', async (req, res) => {
  try {
    const { id: bookId } = req.params; // Lấy bookId từ URL
    const { copyIds } = req.body; // Lấy danh sách copyIds từ body

    // Kiểm tra xem danh sách copyIds có được cung cấp không
    if (!Array.isArray(copyIds) || copyIds.length === 0) {
      return res.status(400).json({ message: 'Vui lòng cung cấp danh sách copyIds để xóa' });
    }

    // Kiểm tra xem sách có tồn tại không
    const book = await Book.findById(bookId);
    if (!book) {
      return res.status(404).json({ message: 'Không tìm thấy sách để xóa bản sao' });
    }

    // Xóa các bản sao có trong danh sách copyIds
    const deleteResult = await CopyBook.deleteMany({
      _id: { $in: copyIds },
      ID_book: bookId, // Đảm bảo bản sao thuộc về sách được chỉ định
    });

    // Kiểm tra số lượng bản sao đã bị xóa
    if (deleteResult.deletedCount === 0) {
      return res.status(404).json({ message: 'Không tìm thấy bản sao nào để xóa' });
    }

    res.status(200).json({
      message: `Đã xóa thành công ${deleteResult.deletedCount} bản sao`,
    });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi xóa bản sao của sách', error });
  }
});


module.exports = router;
