const mongoose = require('mongoose');

const userMistakeSchema = new mongoose.Schema({
  userId: {
    type: String,
    ref: 'users',
    required: true
  },
  lessonId: {
    type: String,
    ref: 'lessons',
    required: true
  },
  exerciseId: {
    type: String,
    ref: 'exercises',
    required: true
  }
  
  
 
 
  
}, {
  timestamps: true
});

const UserMistake = mongoose.model('user_mistakes', userMistakeSchema);

module.exports = UserMistake;
