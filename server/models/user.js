var mongoose = require("mongoose");

var userschama = require("../schemas/users");

module.exports = mongoose.model("User",userschama);
