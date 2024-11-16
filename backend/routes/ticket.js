const express = require('express');
const router = express.Router();
const holdTicket = require('../models/HoldTicket'); 
const borrowTicket = require('../models/BorrowTicket')

router.get('/:id_user/hold', async (req, res) => {
    try {
        const {id_user} = req.params;

        //Get list hold ticket of student
        const holdTickets = await holdTicket.find({ID_student: id_user})
            .populate('ID_book', 'name')
            .exec();
        
        const now = new Date();
        const response = holdTickets.map(ticket => {
            const expired = now > ticket.day_expired;   //Check het han
            const daysLeft = Math.max(0, Math.ceil((ticket.day_expired - now) / (1000 * 60 * 60 * 24))); // Tính ngày còn lại
            
            return {
                ...ticket._doc, 
                expired,
                daysLeft,
            };
        });

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
        const response = borrowTickets.map(ticket => {
            const expired = now > ticket.return_day;   //Check het han
            const daysLeft = Math.max(0, Math.ceil((ticket.return_day - now) / (1000 * 60 * 60 * 24))); // Tính ngày còn lại
            
            return {
                ...ticket._doc, 
                expired,
                daysLeft,
            };
        });

        res.status(200).json(response);
    } catch(err) {
        console.log(err);
        res.status(500).json({message: 'Something went wrong', error: err.message});
    }
});

router.post('/:id/hold', async (req, res) => {
    try {
        const { id } = req.params; // ID của sinh viên
        const { status, quantity, ID_book } = req.body; // Dữ liệu từ client

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