const mongoose = require('mongoose');

const unitSchema = new mongoose.Schema({
  languageId: {
    type: String,
    ref: 'languages',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  
  order: {
    type: Number,
    required: true
  },
 
  
}, {
  timestamps: true
});

const Unit = mongoose.model('units', unitSchema);

module.exports = Unit;
