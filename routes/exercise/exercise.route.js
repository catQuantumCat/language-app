const express = require('express');
const router = express.Router({ mergeParams: true });
const exerciseController = require('../../controllers/exercise/exercise.controller');

const authMiddleware = require('../../middlewares/auth/auth.middleware');

/**
 * @swagger
 * /lesson/{lessonId}/exercises:
 *   get:
 *     summary: Lấy danh sách bài tập theo lesson
 *     tags: [Exercises]
 *     parameters:
 *       - in: path
 *         name: lessonId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Danh sách bài tập
 *       500:
 *         description: Lỗi server
 */
router.get('/', exerciseController.getExercisesByLesson);









module.exports = router;
