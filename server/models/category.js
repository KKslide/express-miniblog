var mongoose = require("mongoose");

var categoryschama = require("../schemas/categories");

module.exports = mongoose.model("Category",categoryschama);