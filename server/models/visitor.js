var mongoose = require('mongoose');

var visitorschema = require('../schemas/visitors');

module.exports = mongoose.model("Visitor",visitorschema)