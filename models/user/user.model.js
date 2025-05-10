const mongoose = require('mongoose');

// Sửa lại schema trong User.model.js

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  fullName: {
    type: String,
    default: ''
  },
  avatar: {
    type: String,
    default: null
  },
  hearts: {
    type: Number,
    default: 5
  },
  experience: {
    type: Number,
    default: 0
  },
  streak: {
    type: Number,
    default: 0
  },
  
  
  languages: [{
    languageId: {
      type: String,
      ref: 'languages'
    },
    lessonId:{
      type: String,
      ref: 'lessons'
    },
    order:{
      type: Number,
      default: 1
    }
  }]
}, {
  timestamps: true
});

const User = mongoose.model('users', userSchema);

module.exports = User;
