const mongoose = require('mongoose');

const leaderboardSchema = new mongoose.Schema({
  userId: {
    type: String,
    ref: 'users',
    required: true
  },
  languageId: {
    type: String,
    ref: 'languages',
    required: true
  },
  weekStartDate: {
    type: Date,
    required: true
  },
  weekEndDate: {
    type: Date,
    required: true
  },
  experienceGained: {
    type: Number,
    default: 0
  },
  rank: {
    type: Number,
    default: 0
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Tạo index cho việc tìm kiếm nhanh
leaderboardSchema.index({ userId: 1, languageId: 1, weekStartDate: 1 }, { unique: true });

const Leaderboard = mongoose.model('leaderboards', leaderboardSchema);

module.exports = Leaderboard;
