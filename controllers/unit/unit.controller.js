const Unit = require('../../models/unit/unit.model');
const UserLessonProgress = require('../../models/user/user_lesson_progress.model');
const User = require('../../models/user/user.model');

// Lấy danh sách unit theo ngôn ngữ
module.exports.getUnitsByLanguage = async (req, res) => {
  try {
    const { languageId } = req.params;
    const { userId } = req.query;

    console.log('languageId:', languageId);
    console.log('userId:', userId);

    const units = await Unit.find({ languageId }).sort({ order: 1 });
    console.log('units:', units);

    let userExperience = 0;
    if (userId) {
      const user = await User.findById(userId);
      console.log('user:', user);
      if (user && Array.isArray(user.languages)) {
        const languageProgress = user.languages.find(
          lang => lang.languageId.toString() === languageId
        );
        console.log('languageProgress:', languageProgress);
        if (languageProgress) {
          userExperience = languageProgress.experience;
        }
      }
    }

    const response = units.map(unit => {
      const unitObj = unit.toObject();
      unitObj.id = unitObj._id.toString();
      delete unitObj._id;

      unitObj.isUnlocked = userExperience >= unitObj.requiredExperience;

      return unitObj;
    });

    res.status(200).json(response);
  } catch (error) {
    console.error('Lỗi khi lấy danh sách unit:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};


