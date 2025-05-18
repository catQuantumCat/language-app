const cron = require('node-cron');
const reminderController = require('./controllers/notification/reminder.controller');

// Kiểm tra và gửi thông báo nhắc nhở mỗi phút
cron.schedule('* * * * *', () => {
  reminderController.checkAndSendReminders();
});

// Kiểm tra và gửi cảnh báo mất streak vào 22:00 mỗi ngày
cron.schedule('0 22 * * *', () => {
  reminderController.checkAndSendStreakWarnings();
});
