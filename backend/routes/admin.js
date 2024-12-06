const express = require('express');
const router = express.Router();
const User = require('../models/User'); // Import model User
const Account = require('../models/Account');
const Book = require('../models/Book'); // Thay thế bằng đường dẫn mô hình của bạn
const HoldTicket = require('../models/HoldTicket'); // Thay thế bằng đường dẫn mô hình của bạn
const BorrowTicket = require('../models/BorrowTicket'); // Thay thế bằng đường dẫn mô hình của bạn



// Lấy tất cả account student
router.get('/user-student', async (req, res) => {
  try {
    // Giả sử tất cả student là những user có `role: "student"` trong User schema
    const students = await Account.find({ Use_Role: 'student' }).lean();

    if (!students || students.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy tài khoản sinh viên nào' });
    }

    res.status(200).json(students);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách tài khoản sinh viên', error });
  }
});




// Tìm tài khoản qua email
router.get('/user-by-account/:email', async (req, res) => {
  try {
    const { email } = req.params;

    const account = await Account.findOne({ Email: email });

    if (!account) {
      return res.status(404).json({ message: 'Không tìm thấy tài khoản' });
    }

    const user = await User.findOne({ ID_user: account._id }).populate('ID_user');

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng thông qua email' });
    }

    res.status(200).json({ message: 'Không có người dùng', user });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi tìm người dùng qua email', error });
  }
});




// Admin ban sinh viên
router.put('/accounts/ban', async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ message: 'Vui lòng cung cấp email của tài khoản' });
    }

    // Tìm tài khoản bằng email
    const account = await Account.findOne({ Email: email });

    if (!account) {
      return res.status(404).json({ message: 'Không tìm thấy tài khoản với email này' });
    }

    // Kiểm tra nếu tài khoản đã bị cấm
    if (account.Status === 'banned') {
      return res.status(400).json({ message: 'Tài khoản này đã bị cấm trước đó' });
    }

    // Cập nhật trạng thái tài khoản thành 'banned'
    account.Status = 'banned';
    await account.save();

    res.status(200).json({ message: 'Tài khoản đã bị cấm thành công', account });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cấm tài khoản', error });
  }
});


//Hàm lấy số Book, HoldTicket
router.get('/getnum', async (req, res) => {
  try {
    // Đếm số lượng tài liệu trong từng collection
    const bookCount = await Book.countDocuments({});
    const holdTicketCount = await HoldTicket.countDocuments({});
    const borrowTicketCount = await BorrowTicket.countDocuments({});

    // Tính số sách mượn trong tuần (Thứ 2 - CN)
    const now = new Date();
    const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 1)); // Thứ 2 đầu tuần
    const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 7));  // Chủ nhật cuối tuần
    const weeklyBorrowCount = await BorrowTicket.countDocuments({
      borrow_day: { $gte: startOfWeek, $lte: endOfWeek },
    });

    // Tính số sách đến hạn trong ngày
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Đặt giờ đầu ngày
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1); // Ngày hôm sau
    const dueToday = await BorrowTicket.find({
      return_day: { $gte: today, $lt: tomorrow },
    }).exec();
    const returnedTodayCount = dueToday.filter(ticket => ticket.status === 'returned').length;
    const notReturnedTodayCount = dueToday.filter(ticket => ticket.status !== 'returned').length;

    // Trả về dữ liệu thống kê
    res.status(200).json({
      message: 'Thống kê thành công',
      data: {
        numBooks: bookCount,
        numHoldTickets: holdTicketCount,
        numBorrowTickets: borrowTicketCount,
        numWeeklyBorrow: weeklyBorrowCount,
        dueToday: {
          total: dueToday.length,
          returned: returnedTodayCount,
          notReturned: notReturnedTodayCount,
        },
      },
    });
  } catch (error) {
    // Xử lý lỗi
    res.status(500).json({
      message: 'Lỗi khi lấy thống kê',
      error: error.message,
    });
  }
});







module.exports = router;
