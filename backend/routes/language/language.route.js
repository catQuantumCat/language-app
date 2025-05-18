const express = require('express');
const router = express.Router();
const languageController = require('../../controllers/language/language.controller');

/**
 * @swagger
 * /languages:
 *   get:
 *     summary: Lấy danh sách ngôn ngữ
 *     tags: [Languages]
 *     responses:
 *       200:
 *         description: Danh sách ngôn ngữ
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   name:
 *                     type: string
 *                   code:
 *                     type: string
 *                   flagUrl:
 *                     type: string
 *                     nullable: true
 *                   description:
 *                     type: string
 *                   isActive:
 *                     type: boolean
 */
router.get('/', languageController.getLanguages);

/**
 * @swagger
 * /languages/{id}:
 *   get:
 *     summary: Lấy chi tiết ngôn ngữ
 *     tags: [Languages]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Chi tiết ngôn ngữ
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 name:
 *                   type: string
 *                 code:
 *                   type: string
 *                 flagUrl:
 *                   type: string
 *                   nullable: true
 *                 description:
 *                   type: string
 *                 isActive:
 *                   type: boolean
 *       404:
 *         description: Không tìm thấy ngôn ngữ
 */
router.get('/:id', languageController.getLanguageById);

module.exports = router;
