const express = require('express');
const router = express.Router({ mergeParams: true });
const lessonController = require('../../controllers/lesson/lesson.controller');

router.get('/', lessonController.getLessonsByUnit);
router.get('/:id', lessonController.getLessonById);

module.exports = router;
