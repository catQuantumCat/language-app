const mongoose = require('mongoose');

const userLessonProgressSchema = new mongoose.Schema({
  userId: {
    type: String,
    ref: 'users',
    required: true
  },
  unitId: {
    type: String,
    ref: 'units',
    required: true
  },
  lessonId: {
    type: String,
    ref: 'lessons',
    required: true
  },
  
  exercises:[{
    exerciseId: {
      type: String,
      ref: 'exercises',
      
    }
  }],
  
  
  hearts: {
    type: Number,
    default: 0
  },
  experienceGained: {
    type: Number,
    default: 0
  },
  timeSpent: {
    type: Number,  // thời gian làm bài tính bằng giây
    default: 0
  },
  streak: {
    type: Number,
    default: 0
  }
  
}, {
  timestamps: true
});



const UserLessonProgress = mongoose.model('user_lesson_progress', userLessonProgressSchema);

module.exports = UserLessonProgress;
