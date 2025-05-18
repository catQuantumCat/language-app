const Unit = require('../../models/unit/unit.model');
const UserLessonProgress = require('../../models/user/user_lesson_progress.model');
const User = require('../../models/user/user.model');

// Lấy danh sách unit theo ngôn ngữ
module.exports.getUnitsByLanguage = async (req, res) => {
  try {
    const { languageId } = req.params;
    

    console.log('languageId:', languageId);
    

    const units = await Unit.find({ languageId }).sort({ order: 1 });
    console.log('units:', units);

   
    

    const response = units.map(unit => {
      const unitObj = unit.toObject();
      unitObj.id = unitObj._id.toString();
      delete unitObj._id;

      

      return unitObj;
    });

    res.status(200).json(response);
  } catch (error) {
    console.error('Lỗi khi lấy danh sách unit:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};


