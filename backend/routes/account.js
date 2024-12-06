const express = require('express');
const router = express.Router();
const Account = require('../models/Account'); // Import the Account model
const User = require('../models/User');       // Import User model
const Student = require('../models/Student')    // Import student model
const Admin = require('../models/Admin');
const bcrypt = require('bcrypt');
// const jwt = require('jsonwebtoken');

// const JWT_SECRET = 'httt'; // Thay bằng khóa bí mật của bạn


router.post('/signup', async (req, res) => {
  try {
    const {email, password, role, status, nam, gen, addr, ava, mssv, dob, fac, numwa, job_des} = req.body;

    // Kiểm tra xem email đã tồn tại hay chưa
    const existingUser = await Account.findOne({ Email: email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email đã tồn tại' });
    }

    // Hash password
    const bcrypt = require('bcrypt');
    const hashedPassword = await bcrypt.hash(password, 10); // Mã hóa mật khẩu

    // Tạo tài khoản mới
    const newAccount = new Account({
      Email: email, 
      HashPassword: hashedPassword, // Dùng mật khẩu đã mã hóa
      Use_Role: role,   // role là student/admin
      Status: status,   // status là on/off
    });

    const savedAccount = await newAccount.save();

    // Tạo người dùng
    const newUser = new User({
      name: nam,
      gender: gen,
      address: addr,
      avatar: ava,
      join_date: Date.now(),
      email: email,
      ID_user: savedAccount._id
    });

    const savedUser = await newUser.save();

    // Xử lý theo role
    if (role === 'student') {
      // Kiểm tra trùng MSSV
      const existingStudent = await Student.findOne({ MSSV: mssv });
      if (existingStudent) {
        // Xóa tài khoản và user vừa tạo để không lưu dữ liệu không hợp lệ
        await Account.findByIdAndDelete(savedAccount._id);
        await User.findByIdAndDelete(savedUser._id);
        return res.status(400).json({ message: 'MSSV đã tồn tại' });
      }

      const newStudent = new Student({
        MSSV: mssv,
        dob: dob,
        faculty: fac,
        NoWarning: numwa,
        ID: savedUser.ID_user,
      });
      await newStudent.save();
    } else if (role === 'admin') {
      const newAdmin = new Admin({
        job_description: job_des,
        ID: savedUser.ID_user,
      });
      await newAdmin.save();
    } else {
      // Xóa tài khoản và user nếu role không hợp lệ
      await Account.findByIdAndDelete(savedAccount._id);
      await User.findByIdAndDelete(savedUser._id);
      return res.status(400).json({ message: 'Role không hợp lệ' });
    }

    res.status(201).json({ message: 'Đăng ký thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng ký', error: error.message });
  }
});




router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Tìm tài khoản theo email
    const account = await Account.findOne({ Email: email });
    if (!account) {
      return res.status(400).json({ message: 'Email không chính xác' });
    }

    // Kiểm tra mật khẩu
    const isMatch = await bcrypt.compare(password, account.HashPassword);
    if (!isMatch) {
      return res.status(400).json({ message: 'Sai mật khẩu' });
    }

    // Lấy thông tin người dùng
    const user = await User.findOne({ ID_user: account._id });
    if (!user) {
      return res.status(404).json({ message: 'User không tồn tại' });
    }

    let data = {};

    if (account.Use_Role === "admin") {
      const ad = await Admin.findOne({ ID: account._id });
      if (!ad) {
        return res.status(404).json({ message: 'Admin không tồn tại' });
      }
      data = {
        userId: user.ID_user,
        name: user.name,
        avatarUrl: user.avatar,
        email: user.email,
        role: account.Use_Role,
        gender: user.gender,
        address: user.address,
        joinDate: user.join_date,
        jobDescription: ad.job_description,
      };
    } else if (account.Use_Role === "student") {
      const stu = await Student.findOne({ ID: account._id });
      if (!stu) {
        return res.status(404).json({ message: 'Student không tồn tại' });
      }
      data = {
        userId: user.ID_user,
        name: user.name,
        avatarUrl: user.avatar,
        email: user.email,
        role: account.Use_Role,
        gender: user.gender,
        address: user.address,
        joinDate: user.join_date,
        MSSV: stu.MSSV,
        doB: stu.dob,
        faculty: stu.faculty,
        noWarning: stu.NoWarning,
        status: account.Status,
      };
    } else {
      return res.status(400).json({ message: 'Role không hợp lệ' });
    }

    res.json({ message: 'Đăng nhập thành công', data });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng nhập', error: error.message });
  }
});

module.exports = router;
