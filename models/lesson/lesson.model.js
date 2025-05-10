const mongoose = require('mongoose');

const lessonSchema = new mongoose.Schema({
  unitId: {
    type: String,
    ref: 'units',
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
  
  experienceReward: {
    type: Number,
    default: 10
  },
  
  
}, {
  timestamps: true
});

const Lesson = mongoose.model('lessons', lessonSchema);

module.exports = Lesson;
