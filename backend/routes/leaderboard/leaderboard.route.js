const express = require('express');
const router = express.Router();
const leaderboardController = require('../../controllers/leaderboard/leaderboard.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

/**
 * @swagger
 * /leaderboard:
 *   get:
 *     summary: Lấy bảng xếp hạng tất cả người dùng
 *     tags: [Leaderboard]
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 50
 *     responses:
 *       200:
 *         description: Bảng xếp hạng
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 leaderboard:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       userId:
 *                         type: string
 *                       username:
 *                         type: string
 *                       fullName:
 *                         type: string
 *                       avatar:
 *                         type: string
 *                         nullable: true
 *                       experience:
 *                         type: number
 *                       languageFlag:
 *                         type: string
 *                       rank:
 *                         type: number
 *                 currentUserRank:
 *                   type: object
 *                   nullable: true
 *                   properties:
 *                     rank:
 *                       type: number
 *                     experience:
 *                       type: number
 */
router.get('/', leaderboardController.getLeaderboard);

/**
 * @swagger
 * /leaderboard/me:
 *   get:
 *     summary: Lấy thứ hạng của người dùng hiện tại
 *     tags: [Leaderboard]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Thứ hạng của người dùng
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 currentUser:
 *                   type: object
 *                   properties:
 *                     userId:
 *                       type: string
 *                     username:
 *                       type: string
 *                     fullName:
 *                       type: string
 *                     avatar:
 *                       type: string
 *                       nullable: true
 *                     experience:
 *                       type: number
 *                     languageFlag:
 *                       type: string
 *                     rank:
 *                       type: number
 *                 aboveUsers:
 *                   type: array
 *                   items:
 *                     type: object
 *                 belowUsers:
 *                   type: array
 *                   items:
 *                     type: object
 *       404:
 *         description: Không tìm thấy thông tin người dùng
 */
router.get('/me', authMiddleware.verifyToken, leaderboardController.getCurrentUserRank);

/**
 * @swagger
 * /leaderboard/user/{userId}:
 *   get:
 *     summary: Lấy thông tin xếp hạng của một người dùng cụ thể
 *     tags: [Leaderboard]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Thông tin xếp hạng của người dùng
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 user:
 *                   type: object
 *                   properties:
 *                     userId:
 *                       type: string
 *                     username:
 *                       type: string
 *                     fullName:
 *                       type: string
 *                     avatar:
 *                       type: string
 *                       nullable: true
 *                     experience:
 *                       type: number
 *                     languageFlag:
 *                       type: string
 *                     rank:
 *                       type: number
 *       404:
 *         description: Không tìm thấy người dùng
 */
router.get('/user/:userId', leaderboardController.getUserRank);

module.exports = router;
