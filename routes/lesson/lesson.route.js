const express = require('express');
const router = express.Router({ mergeParams: true });
const lessonController = require('../../controllers/lesson/lesson.controller');
const userExerciseController = require('../../controllers/exercise/user_exercise.controller');
/**
 * @swagger
 * /unit/{unitId}/lessons:
 *   get:
 *     summary: Lấy danh sách lesson theo unit
 *     tags: [Lessons]
 *     parameters:
 *       - in: path
 *         name: unitId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Danh sách lesson
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   title:
 *                     type: string
 *                   description:
 *                     type: string
 *                   order:
 *                     type: number
 *                   iconUrl:
 *                     type: string
 *                     nullable: true
 *                   experienceReward:
 *                     type: number
 *                   requiredHearts:
 *                     type: number
 *                   timeLimit:
 *                     type: number
 *                     nullable: true
 *                   isActive:
 *                     type: boolean
 *                   progress:
 *                     type: object
 *                     properties:
 *                       completed:
 *                         type: boolean
 *                       score:
 *                         type: number
 *                       attempts:
 *                         type: number
 */
router.get('/', lessonController.getLessonsByUnit);

/**
 * @swagger
 * /unit/{unitId}/lessons/{id}:
 *   get:
 *     summary: Lấy chi tiết lesson
 *     tags: [Lessons]
 *     parameters:
 *       - in: path
 *         name: unitId
 *         required: true
 *         schema:
 *           type: string
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Chi tiết lesson
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 title:
 *                   type: string
 *                 description:
 *                   type: string
 *                 order:
 *                   type: number
 *                 iconUrl:
 *                   type: string
 *                   nullable: true
 *                 experienceReward:
 *                   type: number
 *                 requiredHearts:
 *                   type: number
 *                 timeLimit:
 *                   type: number
 *                   nullable: true
 *                 isActive:
 *                   type: boolean
 *                 exerciseCount:
 *                   type: number
 *                 progress:
 *                   type: object
 *                   properties:
 *                     completed:
 *                       type: boolean
 *                     score:
 *                       type: number
 *                     correctAnswers:
 *                       type: number
 *                     totalExercises:
 *                       type: number
 *                     heartsUsed:
 *                       type: number
 *                     experienceGained:
 *                       type: number
 *                     timeSpent:
 *                       type: number
 *                     attempts:
 *                       type: number
 *       404:
 *         description: Không tìm thấy bài học
 */
router.get('/:id', lessonController.getLessonById);
/**
 * @swagger
 * /unit/{unitId}/lessons/save-results:
 *   post:
 *     summary: Lưu kết quả bài học của người dùng
 *     description: API lưu tiến trình nhiều bài tập trong một bài học, cập nhật thông tin người dùng và lưu lỗi sai
 *     tags: [Lessons]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - lessonId
 *               - exercises
 *             properties:
 *               userId:
 *                 type: string
 *                 description: ID của người dùng
 *               lessonId:
 *                 type: string
 *                 description: ID của bài học
 *               exercises:
 *                 type: array
 *                 description: Danh sách các bài tập và câu trả lời
 *                 items:
 *                   type: object
 *                   required:
 *                     - exerciseId
 *                     - selectedOptionId
 *                   properties:
 *                     exerciseId:
 *                       type: string
 *                       description: ID của bài tập
 *                     
 *               hearts:
 *                 type: number
 *                 description: Tổng số tim người dùng nhận được
 *                 default: 0
 *               experienceGained:
 *                 type: number
 *                 description: Tổng số điểm kinh nghiệm nhận được
 *                 default: 0
 *               timeSpent:
 *                 type: number
 *                 description: Tổng thời gian làm bài (tính bằng giây)
 *                 default: 0
 *               streak:
 *                 type: number
 *                 description: Số streak tăng thêm
 *                 default: 0
 *     responses:
 *       200:
 *         description: Lưu kết quả bài học thành công
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
 *                   example: Đã lưu kết quả bài học thành công
 *                 data:
 *                   type: object
 *                   properties:
 *                     lessonProgress:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           userId:
 *                             type: string
 *                           lessonId:
 *                             type: string
 *                           exerciseId:
 *                             type: string
 *                           selectedOptionId:
 *                             type: string
 *                           hearts:
 *                             type: number
 *                           experienceGained:
 *                             type: number
 *                           timeSpent:
 *                             type: number
 *                           streak:
 *                             type: number
 *                     mistakes:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           userId:
 *                             type: string
 *                           lessonId:
 *                             type: string
 *                           exerciseId:
 *                             type: string
 *                           selectedOptionId:
 *                             type: string
 *                     updatedUser:
 *                       type: object
 *                       properties:
 *                         hearts:
 *                           type: number
 *                         experience:
 *                           type: number
 *                         streak:
 *                           type: number
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
 *                   example: Thiếu thông tin bắt buộc hoặc định dạng exercises không hợp lệ
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
 *                   example: Không tìm thấy người dùng
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
 *                   example: Đã xảy ra lỗi khi lưu kết quả bài học
 *                 error:
 *                   type: string
 */
router.post('/save-results', userExerciseController.saveLessonResults);
module.exports = router;
