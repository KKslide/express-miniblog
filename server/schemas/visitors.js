var mongoose = require('mongoose');

module.exports = new mongoose.Schema({
    ip: String,
    time: {
        type: Date,
        default: new Date()
    }
})