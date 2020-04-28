var mongoose = require("mongoose");

module.exports = new mongoose.Schema({
    name: String,
    addtime: {
        type: Date,
        default: new Date()
    },
    edittime: {
        type: Date,
        default: new Date()
    },
    banner: ""
});