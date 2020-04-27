var mongoose = require("mongoose");

var contentschama = require("../schemas/contents");

module.exports = mongoose.model("Content",contentschama);