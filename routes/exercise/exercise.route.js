const express = require('express');
const router = express.Router({ mergeParams: true });
const exerciseController = require('../../controllers/exercise/exercise.controller');
const userExerciseController = require('../../controllers/exercise/user_exercise.controller');



// Route mới
/**
 * @swagger
 * /lesson/{lessonId}/exercises:
 *   get:
 *     summary: Lấy danh sách bài tập theo lesson
 *     parameters:
 *       - in: path
 *         name: lessonId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Danh sách bài tập
 */
router.get('/', exerciseController.getExercisesByLesson);
router.post('/submit', userExerciseController.submitExerciseResult);
router.post('/lesson/save-results', userExerciseController.saveLessonResults);
router.get('/mistakes/:userId', userExerciseController.getUserMistakes);
router.get('/mistakes/detail/:mistakeId', userExerciseController.getMistakeDetail);
router.post('/mistakes/review/:mistakeId', userExerciseController.reviewMistake);

module.exports = router;
