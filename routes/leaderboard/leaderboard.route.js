const express = require('express');
const router = express.Router();
const leaderboardController = require('../../controllers/leaderboard/leaderboard.controller');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

// Lấy bảng xếp hạng theo ngôn ngữ
router.get('/:languageId', leaderboardController.getLeaderboard);

// Lấy thứ hạng của người dùng hiện tại (yêu cầu đăng nhập)
router.get('/:languageId/me', authMiddleware.verifyToken, leaderboardController.getCurrentUserRank);

module.exports = router;
