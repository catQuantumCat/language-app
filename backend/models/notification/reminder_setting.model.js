const mongoose = require('mongoose');

const reminderSettingSchema = new mongoose.Schema({
  userId: {
    type: String,
    ref: 'users',
    required: true,
    unique: true
  },
  isEnabled: {
    type: Boolean,
    default: true
  },
  reminderTime: {
    type: String,  // Format: HH:MM
    default: '20:00'
  },
  reminderDays: {
    type: [Number],  // 0: Sunday, 1: Monday, ..., 6: Saturday
    default: [0, 1, 2, 3, 4, 5, 6]
  },
  lastReminderSent: {
    type: Date,
    default: null
  }
}, {
  timestamps: true
});

const ReminderSetting = mongoose.model('reminder_settings', reminderSettingSchema);

module.exports = ReminderSetting;
