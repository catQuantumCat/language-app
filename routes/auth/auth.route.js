const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/auth.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Đăng ký tài khoản mới
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *               fullName:
 *                 type: string
 *     responses:
 *       201:
 *         description: Đăng ký thành công
 *       400:
 *         description: Thiếu thông tin
 *       409:
 *         description: Tên đăng nhập hoặc email đã tồn tại
 */
router.post('/register', authController.register);

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Đăng nhập
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Đăng nhập thành công
 *       400:
 *         description: Thiếu thông tin đăng nhập
 *       401:
 *         description: Thông tin đăng nhập không chính xác
 */

router.post('/login', authController.login);

/**
 * @swagger
 * /auth/me:
 *   get:
 *     summary: Lấy thông tin người dùng hiện tại
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Thông tin người dùng
 *       401:
 *         description: Không được ủy quyền
 */

router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

module.exports = router;
