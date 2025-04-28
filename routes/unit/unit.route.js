const express = require('express');
const router = express.Router({ mergeParams: true });
const unitController = require('../../controllers/unit/unit.controller');

router.get('/', unitController.getUnitsByLanguage);

module.exports = router;
