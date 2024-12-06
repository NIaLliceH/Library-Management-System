const express = require('express');
const router = express.Router();
const holdTicket = require('../models/HoldTicket'); 
const borrowTicket = require('../models/BorrowTicket');
const AuthorBook = require('../models/AuthorBook');
const CategoryBook = require("../models/CategoryBook");
const Book = require("../models/Book");
const CopyBook = require('../models/CopyBook');
const HoldTicket = require('../models/HoldTicket');



router.get('/hold', async (req, res) => {
    try {
        const { id_user } = req.params;

        // Lấy danh sách các holdTicket của sinh viên
        const holdTickets = await holdTicket.find().exec();

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
                
                const nameData = await Book.findOne({ _id: ticket.ID_book });

                const nameBook = nameData ? nameData.name : 'Unknown';
                //const urlBook = nameData ? nameData.imageUrl : 'Unknown';

                data = {
                    "holdTicket_ID": ticket._id,
                    // "bookID": ticket.ID_book, 
                    "title": nameBook, 
                    "author": authors, 
                    "category": nameData.category, 
                    "status": ticket.status, 
                    "createdDate": ticket.day_create, 
                    "expiredDate": ticket.day_expired,
                    "dayLeft": daysLeft
                }

                return data;
            })
        );

        // Trả kết quả về client
        res.status(200).json(response);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});


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
                
                const nameData = await Book.findOne({ _id: ticket.ID_book });

                const nameBook = nameData ? nameData.name : 'Unknown';
                //const urlBook = nameData ? nameData.imageUrl : 'Unknown';

                data = {
                    "holdTicket_ID": ticket._id,
                    // "bookID": ticket.ID_book, 
                    "title": nameBook, 
                    "author": authors, 
                    "category": nameData.category, 
                    "status": ticket.status, 
                    "createdDate": ticket.day_create, 
                    "expiredDate": ticket.day_expired,
                    "dayLeft": daysLeft
                }

                return data;
            })
        );

        // Trả kết quả về client
        res.status(200).json(response);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});

router.get('/hold_infor/:id_ticket', async (req, res) => {
    try {
        const { id_ticket } = req.params;


        //Lấy thông tin của holdTicket cụ thể nào đó
        const borrowTicket_one = await holdTicket.findOne({ _id: id_ticket });
        const dataBook = await Book.findOne({ _id: borrowTicket_one.ID_book });
        // Lấy thông tin Author từ AuthorBook
        const authorData = await AuthorBook.find({ ID_book: borrowTicket_one.ID_book }).exec();
        const authors = authorData.map(author => author.author); 


        const url = dataBook.imageUrl ? dataBook.imageUrl : "Unknown";
        const edi = dataBook.edition ? dataBook.edition : "Unknown";

        
        data = { 
            // "bookID": borrowTicket_one.ID_book, 
            // "createdDate": borrowTicket_one.day_create, 
            "expiredDate": borrowTicket_one.day_expired, 
            "status": borrowTicket_one.status,
            "imageUrl": url, 
            "title": dataBook.name, 
            "author": authors, 
            "category": dataBook.category, 
            "edition": edi,
            "canceledDate": borrowTicket_one.cancelAt,
        }



        // Trả kết quả về client
        res.status(200).json(data);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});


router.get('/borrow', async (req, res) => {
    try {
        const {id_user} = req.params;

        // Lấy danh sách tất cả borrow tickets
        const borrowTickets = await borrowTicket.find().exec();
        
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
                const nameData = await Book.findOne({ _id: id_book });
                const nameBook = nameData ? nameData.name : 'Unknown';

                const returnedDate = ticket.returnedDate ? ticket.returnedDate : "Not Yet";



                data = {
                    "borrowTicket_ID": ticket._id,
                    "title": nameBook, 
                    "author": authors, 
                    "createdDate": ticket.borrow_day, 
                    "expiredDate": ticket.return_day,
                    "returnedDate": returnedDate,
                    "status": ticket.status, 
                    "dayLeft": daysLeft
                }
                return data;
            })
        );

        res.status(200).json(response);
    } catch(err) {
        console.log(err);
        res.status(500).json({message: 'Something went wrong', error: err.message});
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
                const nameData = await Book.findOne({ _id: id_book });
                const nameBook = nameData ? nameData.name : 'Unknown';

                const returnedDate = ticket.returnedDate ? ticket.returnedDate : "Not Yet";



                data = {
                    "borrowTicket_ID": ticket._id,
                    "title": nameBook, 
                    "author": authors, 
                    "createdDate": ticket.borrow_day, 
                    "expiredDate": ticket.return_day,
                    "returnedDate": returnedDate,
                    "status": ticket.status, 
                    "dayLeft": daysLeft
                }
                return data;
            })
        );

        res.status(200).json(response);
    } catch(err) {
        console.log(err);
        res.status(500).json({message: 'Something went wrong', error: err.message});
    }
});

router.get('/borrow_infor/:id_ticket', async (req, res) => {
    try {
        const { id_ticket } = req.params;


        //Lấy thông tin của holdTicket cụ thể nào đó
        const borrowTicket_one = await borrowTicket.findOne({ _id: id_ticket });
        const copy = await CopyBook.findOne({ _id: borrowTicket_one.ID_copy });
        const dataBook = await Book.findOne({ _id: copy.ID_book });
        // Lấy thông tin Author từ AuthorBook
        const authorData = await AuthorBook.find({ ID_book: copy.ID_book }).exec();
        const authors = authorData.map(author => author.author); 


        const url = dataBook.imageUrl ? dataBook.imageUrl : "Unknown";
        const edi = dataBook.edition ? dataBook.edition : "Unknown";
        const nameBo = dataBook.name ? dataBook.name : "Unknown";

        
        data = { 
            "bookID": dataBook._id, 
            "createdDate": borrowTicket_one.borrow_day, 
            "expiredDate": borrowTicket_one.return_day, 
            "status": borrowTicket_one.status, 
            "returnedDate": borrowTicket_one.returnedDate, 
            "imageUrl": url, 
            "title": nameBo, 
            "author": authors, 
            "category": dataBook.category, 
            "edition": edi, 
            "hasRated": borrowTicket_one.rated 
        }

        // Trả kết quả về client
        res.status(200).json(data);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Something went wrong', error: err.message });
    }
});

router.post('/:id_user/hold', async (req, res) => {
    try {
        const { id_user } = req.params; // ID của sinh viên
        const { ID_book } = req.body; // Dữ liệu từ client
        const quantity = 1;

        

        // Kiểm tra số lượng holdTicket có status = 0
        const activeHoldTickets = await holdTicket.countDocuments({ ID_student: id_user, status: "valid" });
        if (activeHoldTickets >= 5) {
            return res.status(400).json({ message: 'Không thể giữ nhiều hơn 5 cuốn sách' });
        }

        // Hệ thống tự động gán thời gian tạo và thời gian hết hạn
        const day_create = new Date(); // Thời gian hiện tại
        const holdDuration = 7; // Thời gian giữ chỗ mặc định (7 ngày)
        const day_expired = new Date(day_create.getTime() + holdDuration * 24 * 60 * 60 * 1000); // Thêm 7 ngày vào day_create

        // Tạo một tài liệu mới cho HoldTicket
        const newHoldTicket = new holdTicket({
            status: "valid",
            day_create,
            day_expired,
            quantity,
            ID_student: id_user,
            ID_book,
        });

        // Kiểm tra xem ID_book có nằm trong holdTicket của người dùng hay không
        const holdTic = await holdTicket.findOne({ 
            ID_student: id_user, 
            ID_book: ID_book, 
        });

        if (holdTic) {
            return res.status(200).json({ 
                exists: true, 
                message: 'Bạn đã thực hiện đặt chỗ cuốn sách này rồi' 
            });
        }

        // Lưu vào database
        const savedTicket = await newHoldTicket.save();

        res.status(201).json({ message: 'Tạo thẻ giữ sách thành công', data: savedTicket });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Có lỗi xảy ra', error: err.message });
    }
});


router.post('/:id_user/borrow', async (req, res) => {
    try {
        const { id_user } = req.params; // ID của sinh viên
        const { ID_copy, ID_admin } = req.body; // Dữ liệu từ client

        // Hệ thống tự động gán thời gian mượn và trả
        const borrow_day = new Date(); // Thời gian hiện tại
        const borrowDuration = 14; // Thời gian mượn sách (14 ngày)
        const return_day = new Date(borrow_day.getTime() + borrowDuration * 24 * 60 * 60 * 1000); // Thêm 14 ngày vào borrow_day
        
        // Lấy ID_book từ ID_copy
        const dataBook = await CopyBook.findOne( {_id: ID_copy} );
        const ID_book = dataBook.ID_book;


        // Kiểm tra trùng ID_book trong các HoldTicket của sinh viên
        const existingTicket = await holdTicket.findOne({
            ID_student: id_user,
            ID_book: ID_book, // Trùng sách
            status: "valid" // Chỉ kiểm tra những vé chưa xử lý
        });

        if (existingTicket) {
            // Nếu đã tồn tại vé hold với cùng ID_book, cập nhật status
            existingTicket.status = "cancel";
            existingTicket.cancelAt = borrow_day;
            await existingTicket.save();
        }

        // Kiểm tra xem ID_copy có nằm trong borrowTicket của người dùng hay không
        const borrowTic = await borrowTicket.findOne({ 
            ID_student: id_user, 
            ID_copy: ID_copy, 
        });

        if (borrowTic) {
            return res.status(200).json({ 
                exists: true, 
                message: 'Cuốn sách này đang mượn rồi' 
            });
        }


        // Tạo một tài liệu mới cho BorrowTicket
        const newBorrowTicket = new borrowTicket({
            status: "borrowing",
            borrow_day,
            return_day,
            no_day_left: borrowDuration, // Số ngày mượn còn lại ban đầu là toàn bộ thời gian mượn
            ID_student: id_user,
            ID_copy,
            ID_admin,
        });

        // Lưu vào database
        const savedTicket = await newBorrowTicket.save();

        const data_COuntborrow = await Book.findOne( {_id: ID_book} );
        data_COuntborrow.borrowCount = data_COuntborrow.borrowCount + 1;
        await data_COuntborrow.save();

        res.status(201).json({ message: 'Tạo thẻ mượn sách thành công', data: savedTicket });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Lỗi xảy ra', error: err.message });
    }
});


router.post('/cancel/:ticketID', async (req, res) => {
    try {
        const { ticketID } = req.params; // ID của ticketHold
        const { ID_user } = req.body;   //Dữ liệu của một user nào đó

        const dateNow = new Date();
        const dataHold = await HoldTicket.findOne({ _id: ticketID });
        if (dataHold) {
            dataHold.status = "cancel"; 
            dataHold.cancelAt = dateNow;
            dataHold.cancelBy = ID_user;
            await dataHold.save(); // Lưu thay đổi vào MongoDB
        }

        res.status(201).json({ message: 'Huỷ giữ sách thành công'});
        
    } catch {
        console.error(err);
        res.status(500).json({ message: 'Có lỗi xảy ra', error: err.message });
    }
});

module.exports = router;
