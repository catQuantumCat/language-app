const User = require('../../models/user/user.model');
const Language = require('../../models/language/language.model');

// Lấy bảng xếp hạng tất cả người dùng
module.exports.getLeaderboard = async (req, res) => {
  try {
    const { limit = 50 } = req.query;
    
    // Lấy tất cả người dùng và sắp xếp theo điểm kinh nghiệm
    const users = await User.find({})
      .sort({ experience: -1 })
      .limit(parseInt(limit));
    
    // Lấy thông tin tất cả ngôn ngữ để map với flag
    const languages = await Language.find({});
    const languageMap = {};
    languages.forEach(lang => {
      languageMap[lang._id.toString()] = lang.flagUrl;
    });
    
    // Tạo bảng xếp hạng với đầy đủ thông tin
    const leaderboard = users.map((user, index) => {
      // Lấy ngôn ngữ chính của người dùng (ngôn ngữ đầu tiên trong mảng)
      const primaryLanguage = user.languages && user.languages.length > 0 ? 
        user.languages[0].languageId : null;
      
      const languageFlag = primaryLanguage && languageMap[primaryLanguage] ? 
        languageMap[primaryLanguage] : null;
      
      return {
        userId: user._id.toString(),
        username: user.username,
        fullName: user.fullName || user.username,
        avatar: user.avatar,
        experience: user.experience,
        languageFlag,
        rank: index + 1
      };
    });
    
    // Lấy thứ hạng của người dùng hiện tại (nếu đã đăng nhập)
    let currentUserRank = null;
    if (req.user) {
      const userIndex = users.findIndex(user => user._id.toString() === req.user.id);
      if (userIndex !== -1) {
        currentUserRank = {
          rank: userIndex + 1,
          experience: users[userIndex].experience
        };
      }
    }
    
    res.status(200).json({
      leaderboard,
      currentUserRank
    });
  } catch (error) {
    console.error('Lỗi khi lấy bảng xếp hạng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy bảng xếp hạng' });
  }
};

// Lấy thứ hạng của người dùng hiện tại
module.exports.getCurrentUserRank = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // Lấy tất cả người dùng và sắp xếp theo điểm kinh nghiệm
    const users = await User.find({}).sort({ experience: -1 });
    
    // Tìm vị trí của người dùng hiện tại
    const userIndex = users.findIndex(user => user._id.toString() === userId);
    
    if (userIndex === -1) {
      return res.status(404).json({ message: 'Không tìm thấy thông tin người dùng' });
    }
    
    // Lấy thông tin tất cả ngôn ngữ để map với flag
    const languages = await Language.find({});
    const languageMap = {};
    languages.forEach(lang => {
      languageMap[lang._id.toString()] = lang.flag;
    });
    
    // Lấy thông tin người dùng hiện tại
    const currentUser = users[userIndex];
    const primaryLanguage = currentUser.languages && currentUser.languages.length > 0 ? 
      currentUser.languages[0].languageId : null;
    
    const currentUserInfo = {
      userId: currentUser._id.toString(),
      username: currentUser.username,
      fullName: currentUser.fullName || currentUser.username,
      avatar: currentUser.avatar,
      experience: currentUser.experience,
      languageFlag: primaryLanguage && languageMap[primaryLanguage] ? 
        languageMap[primaryLanguage] : null,
      rank: userIndex + 1
    };
    
    // Lấy 2 người đứng trên
    const aboveUsers = [];
    for (let i = Math.max(0, userIndex - 2); i < userIndex; i++) {
      const user = users[i];
      const userLanguage = user.languages && user.languages.length > 0 ? 
        user.languages[0].languageId : null;
      
      aboveUsers.push({
        userId: user._id.toString(),
        username: user.username,
        fullName: user.fullName || user.username,
        avatar: user.avatar,
        experience: user.experience,
        languageFlag: userLanguage && languageMap[userLanguage] ? 
          languageMap[userLanguage] : null,
        rank: i + 1
      });
    }
    
    // Lấy 2 người đứng dưới
    const belowUsers = [];
    for (let i = userIndex + 1; i < Math.min(users.length, userIndex + 3); i++) {
      const user = users[i];
      const userLanguage = user.languages && user.languages.length > 0 ? 
        user.languages[0].languageId : null;
      
      belowUsers.push({
        userId: user._id.toString(),
        username: user.username,
        fullName: user.fullName || user.username,
        avatar: user.avatar,
        experience: user.experience,
        languageFlag: userLanguage && languageMap[userLanguage] ? 
          languageMap[userLanguage] : null,
        rank: i + 1
      });
    }
    
    res.status(200).json({
      currentUser: currentUserInfo,
      aboveUsers,
      belowUsers
    });
  } catch (error) {
    console.error('Lỗi khi lấy thứ hạng người dùng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy thứ hạng' });
  }
};

// Lấy thông tin xếp hạng của một người dùng cụ thể
module.exports.getUserRank = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Lấy tất cả người dùng và sắp xếp theo điểm kinh nghiệm
    const users = await User.find({}).sort({ experience: -1 });
    
    // Tìm vị trí của người dùng
    const userIndex = users.findIndex(user => user._id.toString() === userId);
    
    if (userIndex === -1) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
    
    // Lấy thông tin tất cả ngôn ngữ để map với flag
    const languages = await Language.find({});
    const languageMap = {};
    languages.forEach(lang => {
      languageMap[lang._id.toString()] = lang.flag;
    });
    
    // Lấy thông tin người dùng
    const user = users[userIndex];
    const primaryLanguage = user.languages && user.languages.length > 0 ? 
      user.languages[0].languageId : null;
    
    const userInfo = {
      userId: user._id.toString(),
      username: user.username,
      fullName: user.fullName || user.username,
      avatar: user.avatar,
      experience: user.experience,
      languageFlag: primaryLanguage && languageMap[primaryLanguage] ? 
        languageMap[primaryLanguage] : null,
      rank: userIndex + 1
    };
    
    res.status(200).json({ user: userInfo });
  } catch (error) {
    console.error('Lỗi khi lấy thông tin xếp hạng người dùng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy thông tin xếp hạng' });
  }
};
