const mongoose = require('mongoose');

const knowledgeSchema = new mongoose.Schema({
  lessonId: {
    type: String,
    ref: 'lessons',
    required: true
  },
  
  vocabulary: [{
    englishWord: {
      type: String,
      required: true
    },
    vietnameseMeaning: {
      type: String,
      required: true
    },
    pronunciation: {
      type: String,
      required: true // Phiên âm
    },
    audioUrl: {
      type: String,
      required: true // Đường dẫn đến file audio phát âm
    },
    examples: [{
      english: String,
      vietnamese: String
    }],
    order: {
      type: Number,
      required: true
    }
  }],
  
  grammar: [{
    title: {
      type: String,
      required: true
    },
    explanation: {
      type: String,
      required: true
    },
    examples: [{
      english: String,
      vietnamese: String
    }],
    order: {
      type: Number,
      required: true
    }
  }],
  
  order: {
    type: Number,
    default: 1
  }
}, {
  timestamps: true
});

const Knowledge = mongoose.model('knowledges', knowledgeSchema);

module.exports = Knowledge;
