// Main routes index
const express = require('express');
const router = express.Router();
const helloRoutes = require('./helloRoutes');

// API routes
router.use('/hello', helloRoutes);

module.exports = router;

