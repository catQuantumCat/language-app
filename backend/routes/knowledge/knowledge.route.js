const express = require('express');
const router = express.Router({ mergeParams: true });
const knowledgeController = require('../../controllers/knowledge/knowledge.controller');

/**
 * @swagger
 * /lesson/{lessonId}/knowledge:
 *   get:
 *     summary: Lấy chi tiết kiến thức của một bài học
 *     tags: [Knowledge]
 *     parameters:
 *       - in: path
 *         name: lessonId
 *         required: true
 *         schema:
 *           type: string
 *       
 *     responses:
 *       200:
 *         description: Chi tiết kiến thức của bài học
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 lessonId:
 *                   type: string
 *                 lessonTitle:
 *                   type: string
 *                 unitId:
 *                   type: string
 *                 vocabulary:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       englishWord:
 *                         type: string
 *                       vietnameseMeaning:
 *                         type: string
 *                       pronunciation:
 *                         type: string
 *                       audioUrl:
 *                         type: string
 *                       examples:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             english:
 *                               type: string
 *                             vietnamese:
 *                               type: string
 *                       order:
 *                         type: number
 *                 grammar:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       title:
 *                         type: string
 *                       explanation:
 *                         type: string
 *                       examples:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             english:
 *                               type: string
 *                             vietnamese:
 *                               type: string
 *                       order:
 *                         type: number
 *                
 */
router.get('/', knowledgeController.getLessonKnowledge);



module.exports = router;
