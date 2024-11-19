require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = 3001;

// Middleware
app.use(express.json()); // Ensure you have this to parse JSON request bodies
console.log('MongoDB URI:', process.env.MONGODB_URI);

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
app.use('/api/books', bookRoutes); // This maps `/api/books` to routes defined in `books.js`
const authen = require('./routes/account');
app.use('/api/authen', authen);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
