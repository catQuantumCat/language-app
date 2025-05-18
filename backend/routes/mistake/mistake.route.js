const express = require('express');
const router = express.Router();
const userExerciseController = require('../../controllers/exercise/user_exercise.controller');

/**
 * @swagger
 * /mistakes/users/{userId}:
 *   get:
 *     summary: Lấy danh sách câu sai của người dùng
 *     tags: [Mistakes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID của người dùng
 *       - in: query
 *         name: languageId
 *         schema:
 *           type: string
 *         description: Lọc theo ngôn ngữ
 *       - in: query
 *         name: unitId
 *         schema:
 *           type: string
 *         description: Lọc theo unit
 *       - in: query
 *         name: lessonId
 *         schema:
 *           type: string
 *         description: Lọc theo lesson
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *         description: Giới hạn số lượng kết quả trả về
 *     responses:
 *       200:
 *         description: Danh sách câu sai
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   exerciseId:
 *                     type: string
 *                   unitOrder:
 *                     type: integer
 *                   unitName:
 *                     type: string
 *                   lessonOrder:
 *                     type: integer
 *                   lessonName:
 *                     type: string
 *                   instruction:
 *                     type: string
 *                   question:
 *                     type: string
 *                   createdAt:
 *                     type: string
 *                     format: date-time
 *       401:
 *         description: Không có quyền truy cập
 *       500:
 *         description: Lỗi server
 */
router.get('/users/:userId', userExerciseController.getUserMistakes);

/**
 * @swagger
 * /mistakes/detail/{mistakeId}:
 *   get:
 *     summary: Lấy chi tiết một câu sai
 *     tags: [Mistakes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: mistakeId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID của câu sai
 *     responses:
 *       200:
 *         description: Chi tiết câu sai
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 unitOrder:
 *                   type: integer
 *                 unitName:
 *                   type: string
 *                 lessonOrder:
 *                   type: integer
 *                 lessonName:
 *                   type: string
 *                 exercise:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                     question:
 *                       type: string
 *                     instruction:
 *                       type: string
 *                     exerciseType:
 *                       type: string
 *                     audioUrl:
 *                       type: string
 *                     imageUrl:
 *                       type: string
 *                     data:
 *                       type: object
 *                 createdAt:
 *                   type: string
 *                   format: date-time
 *       401:
 *         description: Không có quyền truy cập
 *       404:
 *         description: Không tìm thấy câu sai
 *       500:
 *         description: Lỗi server
 */
router.get('/detail/:mistakeId', userExerciseController.getMistakeDetail);

module.exports = router;
