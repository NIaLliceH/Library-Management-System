const express = require('express');
const router = express.Router();
const Account = require('../models/Account'); // Import the Account model
const User = require('../models/User');       // Import User model
const Student = require('../models/Student')    // Import student model
const Admin = require('../models/Admin');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const JWT_SECRET = 'httt'; // Thay bằng khóa bí mật của bạn


router.post('/signup', async (req, res) => {
  try {
    const {email, password, role, status, nam, gen, addr, ava, jod, mssv, dob, fac, numwa, job_des} = req.body;

    //Kiem tra xem email da ton tai hay chua
    const existingUser = await Account.findOne({ Email: email });
    if (existingUser) {
        return res.status(400).json({message: 'Email da ton tai'});
    }

    //Hash password
    //const hashedPassword = await bcrypt.hash(password,  10);

    //create a new user
    const newAccount = new Account({
        Email: email, 
        Password: password,
        Use_Role: role,   //role is student/admin
        Status: status,         //status is on/off
    });


    const savedAccount = await newAccount.save();
    //Hien thuc voi user 
    const newUser = new User({
      name: nam,
      gender: gen,
      address: addr,
      avatar: ava,
      join_date: jod,
      email: email,
      ID_user: savedAccount._id
    });

    const savedUser = await newUser.save();
    //Hien thuc voi Student/Admin
    if (role == 'student') {
      const newStudent = new Student({
        MSSV: mssv,
        dob: dob,
        faculty: fac,
        NoWarning: numwa,
        ID: savedUser.ID_user,
      });
      await newStudent.save();
    }
    else if (role == 'admin') {
      const newAdmin = new Admin({
        job_description: job_des,
        ID: savedUser.ID_user,
      });
      await newAdmin.save();
    }


    res.status(201).json({message: 'Dang ki thanh cong'});
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng kí', error });
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

    //Kiem tra mat khau
    // const isMatch = await bcrypt.compare(password, account.password);
    if (password != account.Password) {
        return res.status(400).json({message: 'Sai mat khau'});
    }

    //Tao token
    //const token = jwt.sign({id: account._id, username: account.Email}, JWT_SECRET, {expiresIn: '1h'});
    
    //Tra ve thong tin cua user vua dang nhap 
    const stu = await Student.findOne({ID: account._id});
    const user = await User.findOne({ID_user: account._id});
    
    res.json({message: 'Dang nhap thanh cong', user: user, student: stu});
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đăng nhập', error });
  }
});

module.exports = router;