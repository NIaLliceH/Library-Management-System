const express = require('express');
const router = express.Router();
const holdTicket = require('../models/HoldTicket'); 
const borrowTicket = require('../models/BorrowTicket');
const AuthorBook = require('../models/AuthorBook');
const CategoryBook = require("../models/CategoryBook");
const Book = require("../models/Book");
const CopyBook = require('../models/CopyBook');

router.get('/:id_user/hold', async (req, res) => {
    try {
        const { id_user } = req.params;

        // Lấy danh sách các holdTicket của sinh viên
        const holdTickets = await holdTicket.find({ ID_student: id_user })
            .exec();

        const now = new Date();

        // Xử lý danh sách holdTicket
        const response = await Promise.all(
            holdTickets.map(async (ticket) => {
                const expired = now > ticket.day_expired; // Kiểm tra hết hạn
                const daysLeft = expired
                    ? 0
                    : Math.ceil((ticket.day_expired - now) / (1000 * 60 * 60 * 24)); // Ngày còn lại

                // Lấy thông tin Author từ AuthorBook
                const authorData = await AuthorBook.find({ ID_book: ticket.ID_book }).exec();
                const authors = authorData.map(author => author.author); 
                            
                //const author = authorData ? authorData.author : 'Unknown';

                // Lấy thông tin Category từ CategoryBook
                const holdData = await CategoryBook.findOne({ ID_book: ticket.ID_book });
                const category = holdData ? holdData.Category : 'Unknown';

                // Lấy thông tin Category từ CategoryBook
                const nameData = await Book.findOne({ _id: ticket.ID_book });
                const nameBook = nameData ? nameData.name : 'Unknown';
                //const urlBook = nameData ? nameData.imageUrl : 'Unknown';

                retu = {
                    "holdTicket_ID": ticket._id,
                    "bookID": ticket.ID_book, 
                    "title": nameBook, 
                    "author": authors, 
                    "category": category, 
                    "status": ticket.status, 
                    "createdDate": ticket.day_create, 
                    "expiredDate": ticket.day_expired,
                    "dayLeft": daysLeft
                }

                return retu;
            })
        );

        // Trả kết quả về client
        res.status(200).json(response);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});

router.get('/:id_user/hold_infor/:id_ticket', async (req, res) => {
    try {
        const { id_user, id_ticket } = req.params;


        //Lấy thông tin của holdTicket cụ thể nào đó
        const borrowTicket_one = await holdTicket.findOne({ _id: id_ticket });
        const dataBook = await Book.findOne({ _id: borrowTicket_one.ID_book });
        // Lấy thông tin Author từ AuthorBook
        const authorData = await AuthorBook.find({ ID_book: borrowTicket_one.ID_book }).exec();
        const authors = authorData.map(author => author.author); 

        const holdData = await CategoryBook.findOne({ ID_book: borrowTicket_one.ID_book });
        const category = holdData ? holdData.Category : 'Unknown';

        const url = dataBook.imageUrl ? dataBook.imageUrl : "Unknown";
        const edi = dataBook.edition ? dataBook.edition : "Unknown";

        
        retu = { 
            "bookID": borrowTicket_one.ID_book, 
            "createdDate": borrowTicket_one.day_create, 
            "expiredDate": borrowTicket_one.day_expired, 
            "status": borrowTicket_one.status, 
            "imageUrl": url, 
            "title": dataBook.name, 
            "author": authors, 
            "category": category, 
            "edition": edi,
            
        }



        // Trả kết quả về client
        res.status(200).json(retu);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});


router.get('/:id_user/borrow', async (req, res) => {
    try {
        const {id_user} = req.params;

        //Get list borrow ticket of student
        const borrowTickets = await borrowTicket.find({ID_student: id_user})
            .exec();
        
        const now = new Date();
        // Xử lý danh sách borrowTicket
        const response = await Promise.all(
            borrowTickets.map(async (ticket) => {
                const expired = now > ticket.return_day; // Kiểm tra hết hạn
                const daysLeft = expired
                    ? 0
                    : Math.ceil((ticket.return_day - now) / (1000 * 60 * 60 * 24)); // Ngày còn lại

                
                //Lấy ID_book từ ID_copy
                const copyData = await CopyBook.findOne({ _id: ticket.ID_copy })
                const id_book = copyData ? copyData.ID_book : '0';

                // Lấy thông tin Author từ AuthorBook
                const authorData = await AuthorBook.find({ ID_book: id_book }).exec();
                const authors = authorData.map(author => author.author); 

                // Lấy thông tin Category từ CategoryBook
                const holdData = await CategoryBook.findOne({ ID_book: id_book });
                const category = holdData ? holdData.Category : 'Unknown';

                // Lấy thông tin Category từ CategoryBook
                const nameData = await Book.findOne({ _id: id_book });
                const nameBook = nameData ? nameData.name : 'Unknown';
                const urlBook = nameData ? nameData.imageUrl : 'Unknown';

                const returnedDate = ticket.returnedDate ? ticket.returnedDate : "Not Yet";



                retu = {
                    "borrowTicket_ID": ticket._id,
                    "title": nameBook, 
                    "author": authors, 
                    "createdDate": ticket.borrow_day, 
                    "expiredDate": ticket.return_day,
                    "returnedDate": returnedDate,
                    "status": ticket.status, 
                    "dayLeft": daysLeft
                }

                return retu;
            })
        );
        // const response = borrowTickets.map(ticket => {
        //     const expired = now > ticket.return_day;   //Check het han
        //     const daysLeft = Math.max(0, Math.ceil((ticket.return_day - now) / (1000 * 60 * 60 * 24))); // Tính ngày còn lại
            
        //     return {
        //         ...ticket._doc, 
        //         expired,
        //         daysLeft,
        //     };
        // });

        res.status(200).json(retu);
    } catch(err) {
        console.log(err);
        res.status(500).json({message: 'Something went wrong', error: err.message});
    }
});

router.get('/:id_user/borrow_infor/:id_ticket', async (req, res) => {
    try {
        const { id_user, id_ticket } = req.params;


        //Lấy thông tin của holdTicket cụ thể nào đó
        const borrowTicket_one = await borrowTicket.findOne({ _id: id_ticket });
        const copy = await CopyBook.findOne({ _id: borrowTicket_one.ID_copy });
        const dataBook = await Book.findOne({ _id: copy.ID_book });
        // Lấy thông tin Author từ AuthorBook
        const authorData = await AuthorBook.find({ ID_book: copy.ID_book }).exec();
        const authors = authorData.map(author => author.author); 

        const holdData = await CategoryBook.findOne({ ID_book: copy.ID_book });
        const category = holdData ? holdData.Category : 'Unknown';

        const url = dataBook.imageUrl ? dataBook.imageUrl : "Unknown";
        const edi = dataBook.edition ? dataBook.edition : "Unknown";
        const nameBo = dataBook.name ? dataBook.name : "Unknown";

        
        retu = { 
            "bookID": dataBook._id, 
            "copyId": borrowTicket_one.ID_copy, 
            "createdDate": borrowTicket_one.borrow_day, 
            "expiredDate": borrowTicket_one.return_day, 
            "status": borrowTicket_one.status, 
            "returnedDate": borrowTicket_one.returnedDate, 
            "imageUrl": url, 
            "title": nameBo, 
            "author": authors, 
            "category": category, 
            "edition": edi, 
            "hasRated": borrowTicket_one.rated 
        }



        // Trả kết quả về client
        res.status(200).json(retu);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});

router.post('/:id/hold', async (req, res) => {
    try {
        const { id } = req.params; // ID của sinh viên
        const { status, ID_book } = req.body; // Dữ liệu từ client
        const quantity = 1;

        

        // Kiểm tra số lượng holdTicket có status = 1
        const activeHoldTickets = await holdTicket.countDocuments({ ID_student: id, status: 1 });
        if (activeHoldTickets >= 5) {
            return res.status(400).json({ message: 'Thất bại, Vượt quá số lượng hold là 5' });
        }

        // Hệ thống tự động gán thời gian tạo và thời gian hết hạn
        const day_create = new Date(); // Thời gian hiện tại
        const holdDuration = 7; // Thời gian giữ chỗ mặc định (7 ngày)
        const day_expired = new Date(day_create.getTime() + holdDuration * 24 * 60 * 60 * 1000); // Thêm 7 ngày vào day_create

        // Tạo một tài liệu mới cho HoldTicket
        const newHoldTicket = new holdTicket({
            status,
            day_create,
            day_expired,
            quantity,
            ID_student: id,
            ID_book,
        });

        // Kiểm tra xem ID_book có nằm trong holdTicket của người dùng hay không
        const holdTic = await holdTicket.findOne({ 
            ID_student: id, 
            ID_book: ID_book, 
        });

        if (holdTic) {
            return res.status(200).json({ 
                exists: true, 
                message: 'The book is already in the hold tickets.' 
            });
        }

        // Lưu vào database
        const savedTicket = await newHoldTicket.save();

        res.status(201).json({ message: 'Hold ticket created successfully!', data: savedTicket });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Error creating hold ticket', error: err.message });
    }
});


router.post('/:id/borrow', async (req, res) => {
    try {
        const { id } = req.params; // ID của sinh viên
        const { status, ID_copy, ID_admin } = req.body; // Dữ liệu từ client

        // Hệ thống tự động gán thời gian mượn và trả
        const borrow_day = new Date(); // Thời gian hiện tại
        const borrowDuration = 14; // Thời gian mượn sách (14 ngày)
        const return_day = new Date(borrow_day.getTime() + borrowDuration * 24 * 60 * 60 * 1000); // Thêm 14 ngày vào borrow_day

        // Tạo một tài liệu mới cho BorrowTicket
        const newBorrowTicket = new borrowTicket({
            status,
            borrow_day,
            return_day,
            no_day_left: borrowDuration, // Số ngày mượn còn lại ban đầu là toàn bộ thời gian mượn
            ID_student: id,
            ID_copy,
            ID_admin,
        });

        // Lưu vào database
        const savedTicket = await newBorrowTicket.save();

        res.status(201).json({ message: 'Borrow ticket created successfully!', data: savedTicket });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Error creating borrow ticket', error: err.message });
    }
});


module.exports = router;