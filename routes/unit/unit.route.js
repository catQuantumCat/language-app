const express = require('express');
const router = express.Router({ mergeParams: true });
const unitController = require('../../controllers/unit/unit.controller');

/**
 * @swagger
 * /languages/{languageId}/units:
 *   get:
 *     summary: Lấy danh sách unit theo ngôn ngữ
 *     tags: [Units]
 *     parameters:
 *       - in: path
 *         name: languageId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Danh sách unit
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
 *                   requiredExperience:
 *                     type: number
 *                   isActive:
 *                     type: boolean
 *                   isUnlocked:
 *                     type: boolean
 */
router.get('/', unitController.getUnitsByLanguage);

module.exports = router;
