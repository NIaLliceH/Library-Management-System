const express = require('express');
const mongoose = require('mongoose');
const http = require('http');
const { Server } = require('socket.io');
const cron = require('node-cron');
require('dotenv').config();

//Models
const BorrowTicket = require('./models/BorrowTicket')


const app = express();
const PORT = 3001;

// Middleware
app.use(express.json()); // Ensure you have this to parse JSON request bodies

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((error) => {
    console.error('MongoDB connection error:', error);
  });

// Route setup
const bookRoutes = require('./routes/books'); // Adjust path if needed
const authen = require('./routes/account');
const tickets = require('./routes/ticket');
const { connect } = require('http2');
app.use('/api/books', bookRoutes); // This maps `/api/books` to routes defined in `books.js`
app.use('/api/authen', authen);
app.use('/api/', tickets)

//Create HTTP server and integrate with Socket.IO
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});


//Socket.IO: Manage 
const connectedUsers = new Map();

io.on('connection', (socket) => {
  console.log('User connected: ', socket.id);

  //register user by ID
  socket.on('registerUser', (userId) => {
    connectedUsers.set(userId, socket.id);
    console.log(`User ${userId} registed with socket ID: ${socket.id}`);
  });

  //Handle disconnection
  socket.on('disconnect', () => {
    connectedUsers.forEach((value, key) => {
      if (value === socket.id) {
        connectedUsers.delete(key);
      }
    });
    console.log('User disconnected: ', socket.id);
  });
});


//function to check due books and notify users
const checkDueBooks = async () => {
  try {
    const today = new Date();
    const tomorrow = new Date();
    tomorrow.setDate(today.getDate() + 1);

    const borrows = await BorrowTicket.find({
      return_day: {$gte: today, $lt: tomorrow},
      status: 'borrowed',
    }).populate('ID_student');  //get borrowed incomming time to return 

    borrows.forEach((borrow) => {
      const user = borrow.ID_student;
      if (user && connectedUsers.has(user._id.toString())) {
        const socketId = connectedUsers.get(user._id.toString());
        io.to(socketId).emit('dueRemainder', {
          message: `Hello ${user.name}, your borrowed book is due tomorrow. Please return in time!!!`,
        });
        console.log("Notify was sent!");
      }
    });
    console.log("Checked due book");
  } catch (error) {
    console.error('Error while checking: ', error);
  }
};

//cron job: Schedule daily task to check due books
cron.schedule('0 9 * * *', () => {
  console.log('Running daily due date check...');
  checkDueBooks();
});



// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

//Export `io`
module.exports = io;
