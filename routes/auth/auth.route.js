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
 *             required:
 *               - username
 *               - email
 *               - password
 *             properties:
 *               username:
 *                 type: string
 *                 description: Tên đăng nhập
 *               email:
 *                 type: string
 *                 format: email
 *                 description: Địa chỉ email
 *               password:
 *                 type: string
 *                 format: password
 *                 description: Mật khẩu
 *               fullName:
 *                 type: string
 *                 description: Họ và tên đầy đủ
 *     responses:
 *       201:
 *         description: Đăng ký thành công
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 username:
 *                   type: string
 *                 email:
 *                   type: string
 *                 fullName:
 *                   type: string
 *                 avatar:
 *                   type: string
 *                   nullable: true
 *                 hearts:
 *                   type: number
 *                 experience:
 *                   type: number
 *                 streak:
 *                   type: number
 *                 languages:
 *                   type: array
 *                   items:
 *                     type: object
 *                 token:
 *                   type: string
 *       400:
 *         description: Thiếu thông tin cần thiết
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
 *             required:
 *               - username
 *               - password
 *             properties:
 *               username:
 *                 type: string
 *                 description: Tên đăng nhập hoặc email
 *               password:
 *                 type: string
 *                 format: password
 *                 description: Mật khẩu
 *     responses:
 *       200:
 *         description: Đăng nhập thành công
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 username:
 *                   type: string
 *                 email:
 *                   type: string
 *                 fullName:
 *                   type: string
 *                 avatar:
 *                   type: string
 *                   nullable: true
 *                 hearts:
 *                   type: number
 *                 experience:
 *                   type: number
 *                 streak:
 *                   type: number
 *                 languages:
 *                   type: array
 *                   items:
 *                     type: object
 *                 token:
 *                   type: string
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
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 username:
 *                   type: string
 *                 email:
 *                   type: string
 *                 fullName:
 *                   type: string
 *                 avatar:
 *                   type: string
 *                   nullable: true
 *                 hearts:
 *                   type: number
 *                 experience:
 *                   type: number
 *                 streak:
 *                   type: number
 *                 languages:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       languageId:
 *                         type: string
 *                       level:
 *                         type: number
 *                       experience:
 *                         type: number
 *       401:
 *         description: Không được ủy quyền
 *       404:
 *         description: Không tìm thấy người dùng
 */
router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

module.exports = router;
