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
      return res.status(400).json({ message: 'Role không hợp lệ' });
    }

    res.status(201).json({ message: 'Đăng ký thành công' });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng ký', error: error.message });
  }
});



router.post('/login', async (req, res) => {
  try {
    const {email, password} = req.body;
    
    //Tìm tài khoản theo username
    const account = await Account.findOne({Email: email});
    if (!account) {
        return res.status(400).json({message: 'Sai email'});
    }

    // if (account.Use_Role != user_role) {
    //   return res.status(400).json({message: 'Not allow'});
    // }

    //Kiem tra mat khau
    const isMatch = await bcrypt.compare(password, account.HashPassword);
    if (!isMatch) {
        return res.status(400).json({message: 'Sai mat khau'});
    }

    //Tao token
    //const token = jwt.sign({id: account._id, username: account.Email}, JWT_SECRET, {expiresIn: '1h'});
    
    //Tra ve thong tin cua user vua dang nhap 
    const stu = await Student.findOne({ID: account._id});
    const user = await User.findOne({ID_user: account._id});

    const retu = {
      "ID_user": user.ID_user, 
      "name": user.name, 
      "avatar": user.avatar, 
      // "role": account.Use_Role, 
      "gender": user.gender, 
      "address": user.address, 
      "join_date": user.join_date, 
      "MSSV": stu.MSSV, 
      "dob": stu.dob, 
      "faculty": stu.faculty, 
      "NoWarning": stu.NoWarning, 
      "status": account.Status, 
    }
    
    res.json({message: 'Dang nhap thanh cong', retu});
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng nhập', error });
  }
});

module.exports = router;