const express = require('express');
const router = express.Router();
const User = require('../models/User'); // Import model User
const Account = require('../models/Account');

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
module.exports = router;
