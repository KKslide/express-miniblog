var mongoose = require("mongoose");

module.exports = new mongoose.Schema({
    viewer: String,
    subject: String,
    massage: String,
    addtime: {
        type: String,
        default: new Date()
    }
});
