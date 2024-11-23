const express = require('express');
const router = express.Router();
const User = require('../models/User'); // Import model User


// Lấy tất cả thông tin của user là student
router.get('/students', async (req, res) => {
  try {
    // Giả sử tất cả student là những user có `role: "student"` trong User schema
    const students = await User.find({ role: 'student' }).lean();

    if (!students || students.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy sinh viên nào' });
    }

    res.status(200).json(students);
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi lấy danh sách sinh viên', error });
  }
});

// Thêm user mới
router.post('/users', async (req, res) => {
  try {
    const { name, gender, address, avatar, join_date, email, ID_user, role } = req.body;

    if (!name || !email || !role) {
      return res.status(400).json({ message: 'Vui lòng cung cấp đầy đủ thông tin người dùng' });
    }

    const newUser = new User({
      name,
      gender,
      address,
      avatar,
      join_date: join_date || new Date(),
      email,
      ID_user,
      role,
    });

    const savedUser = await newUser.save();
    res.status(201).json({ message: 'Thêm user thành công', user: savedUser });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi thêm user', error });
  }
});

// Xóa user theo ID
router.delete('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const deletedUser = await User.findByIdAndDelete(id);

    if (!deletedUser) {
      return res.status(404).json({ message: 'Không tìm thấy user để xóa' });
    }

    res.status(200).json({ message: 'Xóa user thành công', user: deletedUser });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi xóa user', error });
  }
});

// Cập nhật thông tin user
router.put('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, gender, address, avatar, email, role } = req.body;

    const updatedUser = await User.findByIdAndUpdate(
      id,
      { name, gender, address, avatar, email, role },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ message: 'Không tìm thấy user để cập nhật' });
    }

    res.status(200).json({ message: 'Cập nhật user thành công', user: updatedUser });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi cập nhật user', error });
  }
});

module.exports = router;
