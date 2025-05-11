const express = require('express');
const router = express.Router();
const userController = require('../../controllers/user/user.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');
const userExerciseController = require('../../controllers/exercise/user_exercise.controller');

/**
 * @swagger
 * /users/{userId}/profile:
 *   patch:
 *     summary: Cập nhật thông tin cá nhân
 *     tags: [Users]
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
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               fullName:
 *                 type: string
 *                 description: Tên đầy đủ của người dùng
 *               email:
 *                 type: string
 *                 format: email
 *                 description: Email mới của người dùng
 *               password:
 *                 type: string
 *                 format: password
 *                 description: Mật khẩu mới của người dùng
 *               avatar:
 *                 type: string
 *                 format: binary
 *                 description: Tệp hình ảnh avatar mới
 *     responses:
 *       200:
 *         description: Thông tin đã được cập nhật
 *       400:
 *         description: Dữ liệu không hợp lệ
 *       403:
 *         description: Không có quyền cập nhật
 *       404:
 *         description: Không tìm thấy người dùng
 *       409:
 *         description: Email đã được sử dụng
 *       500:
 *         description: Lỗi server
 */
router.patch('/:userId/profile', authMiddleware.verifyToken, userController.uploadAvatar, userController.updateUserProfile);








/**
 * @swagger
 * /users/{userId}/update-language:
 *   patch:
 *     summary: Cập nhật thông tin ngôn ngữ của người dùng
 *     description: API cập nhật ngôn ngữ đã chọn gần đây và/hoặc thêm/cập nhật ngôn ngữ trong danh sách ngôn ngữ của người dùng
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID của người dùng
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               languageId:
 *                 type: string
 *                 description: ID của ngôn ngữ cần thêm/cập nhật trong danh sách
 *               lessonId:
 *                 type: string
 *                 description: ID của bài học hiện tại cho ngôn ngữ đã chọn
 *               order:
 *                 type: number
 *                 description: Thứ tự của ngôn ngữ trong danh sách
 *     responses:
 *       200:
 *         description: Cập nhật thông tin ngôn ngữ thành công
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Cập nhật thông tin ngôn ngữ thành công"
 *                 data:
 *                   type: object
 *                   properties:
 *                     languages:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           languageId:
 *                             type: string
 *                           lessonId:
 *                             type: string
 *                           order:
 *                             type: number
 *       400:
 *         description: Dữ liệu đầu vào không hợp lệ
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Cần cung cấp thông tin languageId"
 *       404:
 *         description: Không tìm thấy người dùng
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Không tìm thấy người dùng"
 *       500:
 *         description: Lỗi server
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Đã xảy ra lỗi khi cập nhật thông tin ngôn ngữ"
 *                 error:
 *                   type: string
 */
router.patch('/:userId/update-language', userController.updateUserLanguage);


module.exports = router;
