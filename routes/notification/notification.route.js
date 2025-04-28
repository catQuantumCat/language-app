const express = require('express');
const router = express.Router();
const notificationController = require('../../controllers/notification/notification.controller');
const reminderController = require('../../controllers/notification/reminder.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

// Các route cho thông báo (yêu cầu đăng nhập)
router.get('/:userId', authMiddleware.verifyToken, notificationController.getUserNotifications);
router.patch('/:userId/:notificationId/read', authMiddleware.verifyToken, notificationController.markNotificationAsRead);
router.patch('/:userId/read-all', authMiddleware.verifyToken, notificationController.markAllNotificationsAsRead);
router.delete('/:userId/:notificationId', authMiddleware.verifyToken, notificationController.deleteNotification);

// Các route cho cài đặt nhắc nhở (yêu cầu đăng nhập)
router.get('/:userId/reminder-settings', authMiddleware.verifyToken, reminderController.getReminderSettings);
router.patch('/:userId/reminder-settings', authMiddleware.verifyToken, reminderController.updateReminderSettings);

module.exports = router;
