var mongoose = require("mongoose");

var msgschama = require("../schemas/massage");

module.exports = mongoose.model("Massage", msgschama);