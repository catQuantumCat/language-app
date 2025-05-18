const express = require('express');
const router = express.Router();
const notificationController = require('../../controllers/notification/notification.controller');
const reminderController = require('../../controllers/notification/reminder.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

/**
 * @swagger
 * /notifications/{userId}:
 *   get:
 *     summary: Lấy danh sách thông báo của người dùng
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 20
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [reminder, streak, achievement, system]
 *     responses:
 *       200:
 *         description: Danh sách thông báo
 *       403:
 *         description: Không có quyền truy cập
 */
router.get('/:userId', authMiddleware.verifyToken, notificationController.getUserNotifications);

/**
 * @swagger
 * /notifications/{userId}/{notificationId}/read:
 *   patch:
 *     summary: Đánh dấu thông báo đã đọc
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *       - in: path
 *         name: notificationId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Đã đánh dấu thông báo là đã đọc
 *       403:
 *         description: Không có quyền truy cập
 *       404:
 *         description: Không tìm thấy thông báo
 */
router.patch('/:userId/:notificationId/read', authMiddleware.verifyToken, notificationController.markNotificationAsRead);

/**
 * @swagger
 * /notifications/{userId}/read-all:
 *   patch:
 *     summary: Đánh dấu tất cả thông báo đã đọc
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Đã đánh dấu tất cả thông báo là đã đọc
 *       403:
 *         description: Không có quyền truy cập
 */
router.patch('/:userId/read-all', authMiddleware.verifyToken, notificationController.markAllNotificationsAsRead);

/**
 * @swagger
 * /notifications/{userId}/{notificationId}:
 *   delete:
 *     summary: Xóa thông báo
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *       - in: path
 *         name: notificationId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Đã xóa thông báo thành công
 *       403:
 *         description: Không có quyền xóa
 *       404:
 *         description: Không tìm thấy thông báo
 */
router.delete('/:userId/:notificationId', authMiddleware.verifyToken, notificationController.deleteNotification);

/**
 * @swagger
 * /notifications/{userId}/reminder-settings:
 *   get:
 *     summary: Lấy cài đặt nhắc nhở của người dùng
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Cài đặt nhắc nhở
 *       403:
 *         description: Không có quyền truy cập
 */
router.get('/:userId/reminder-settings', authMiddleware.verifyToken, reminderController.getReminderSettings);

/**
 * @swagger
 * /notifications/{userId}/reminder-settings:
 *   patch:
 *     summary: Cập nhật cài đặt nhắc nhở
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               isEnabled:
 *                 type: boolean
 *               reminderTime:
 *                 type: string
 *                 description: Format HH:MM
 *               reminderDays:
 *                 type: array
 *                 items:
 *                   type: number
 *                   minimum: 0
 *                   maximum: 6
 *     responses:
 *       200:
 *         description: Đã cập nhật cài đặt nhắc nhở thành công
 *       400:
 *         description: Định dạng dữ liệu không hợp lệ
 *       403:
 *         description: Không có quyền cập nhật
 */
router.patch('/:userId/reminder-settings', authMiddleware.verifyToken, reminderController.updateReminderSettings);

module.exports = router;
