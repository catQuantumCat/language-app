const Leaderboard = require('../../models/leaderboard/leaderboard.model');
const User = require('../../models/user/user.model');
const UserLessonProgress = require('../../models/user/user_lesson_progress.model');
const Lesson = require('../../models/lesson/lesson.model');
const Unit = require('../../models/unit/unit.model');

// Hàm lấy ngày bắt đầu và kết thúc của tuần hiện tại
const getCurrentWeekDates = () => {
  const now = new Date();
  // Lấy ngày đầu tuần (Thứ Hai)
  const startOfWeek = new Date(now);
  startOfWeek.setHours(0, 0, 0, 0);
  startOfWeek.setDate(now.getDate() - now.getDay() + (now.getDay() === 0 ? -6 : 1));
  
  // Lấy ngày cuối tuần (Chủ Nhật)
  const endOfWeek = new Date(startOfWeek);
  endOfWeek.setDate(startOfWeek.getDate() + 6);
  endOfWeek.setHours(23, 59, 59, 999);
  
  return { startOfWeek, endOfWeek };
};

// Cập nhật bảng xếp hạng khi người dùng hoàn thành bài học
module.exports.updateLeaderboard = async (userId, languageId, experienceGained) => {
  try {
    const { startOfWeek, endOfWeek } = getCurrentWeekDates();
    
    // Tìm bản ghi leaderboard của người dùng trong tuần hiện tại
    let leaderboard = await Leaderboard.findOne({
      userId,
      languageId,
      weekStartDate: { $lte: new Date() },
      weekEndDate: { $gte: new Date() }
    });
    
    if (leaderboard) {
      // Cập nhật điểm kinh nghiệm
      leaderboard.experienceGained += experienceGained;
      leaderboard.lastUpdated = new Date();
      await leaderboard.save();
    } else {
      // Tạo bản ghi mới
      leaderboard = new Leaderboard({
        userId,
        languageId,
        weekStartDate: startOfWeek,
        weekEndDate: endOfWeek,
        experienceGained,
        lastUpdated: new Date()
      });
      await leaderboard.save();
    }
    
    // Cập nhật thứ hạng cho tất cả người dùng
    await updateRankings(languageId, startOfWeek, endOfWeek);
    
    return leaderboard;
  } catch (error) {
    console.error('Lỗi khi cập nhật bảng xếp hạng:', error);
    throw error;
  }
};

// Cập nhật thứ hạng cho tất cả người dùng
const updateRankings = async (languageId, startOfWeek, endOfWeek) => {
  try {
    // Lấy tất cả bản ghi trong tuần hiện tại, sắp xếp theo điểm kinh nghiệm
    const leaderboards = await Leaderboard.find({
      languageId,
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek
    }).sort({ experienceGained: -1 });
    
    // Cập nhật thứ hạng
    for (let i = 0; i < leaderboards.length; i++) {
      leaderboards[i].rank = i + 1;
      await leaderboards[i].save();
    }
  } catch (error) {
    console.error('Lỗi khi cập nhật thứ hạng:', error);
    throw error;
  }
};

// API lấy bảng xếp hạng theo ngôn ngữ
module.exports.getLeaderboard = async (req, res) => {
  try {
    const { languageId } = req.params;
    const { limit = 50 } = req.query;
    
    const { startOfWeek, endOfWeek } = getCurrentWeekDates();
    
    // Lấy bảng xếp hạng tuần hiện tại
    const leaderboards = await Leaderboard.find({
      languageId,
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek
    }).sort({ experienceGained: -1, lastUpdated: 1 }).limit(parseInt(limit));
    
    // Lấy thông tin người dùng
    const leaderboardWithUserInfo = await Promise.all(leaderboards.map(async (item) => {
      const user = await User.findById(item.userId);
      
      return {
        id: item._id.toString(),
        userId: item.userId,
        username: user ? user.username : 'Unknown',
        fullName: user ? user.fullName : 'Unknown',
        avatar: user ? user.avatar : null,
        experienceGained: item.experienceGained,
        rank: item.rank
      };
    }));
    
    // Lấy thứ hạng của người dùng hiện tại (nếu có)
    let currentUserRank = null;
    if (req.user) {
      const userLeaderboard = await Leaderboard.findOne({
        userId: req.user.id,
        languageId,
        weekStartDate: startOfWeek,
        weekEndDate: endOfWeek
      });
      
      if (userLeaderboard) {
        currentUserRank = {
          rank: userLeaderboard.rank,
          experienceGained: userLeaderboard.experienceGained
        };
      }
    }
    
    res.status(200).json({
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek,
      leaderboard: leaderboardWithUserInfo,
      currentUserRank
    });
  } catch (error) {
    console.error('Lỗi khi lấy bảng xếp hạng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy bảng xếp hạng' });
  }
};

// API lấy thứ hạng của người dùng hiện tại
module.exports.getCurrentUserRank = async (req, res) => {
  try {
    const { languageId } = req.params;
    const userId = req.user.id;
    
    const { startOfWeek, endOfWeek } = getCurrentWeekDates();
    
    // Lấy thông tin bảng xếp hạng của người dùng
    const userLeaderboard = await Leaderboard.findOne({
      userId,
      languageId,
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek
    });
    
    if (!userLeaderboard) {
      return res.status(404).json({ 
        message: 'Bạn chưa có thành tích trong tuần này',
        weekStartDate: startOfWeek,
        weekEndDate: endOfWeek
      });
    }
    
    // Lấy 2 người đứng trên và 2 người đứng dưới
    const aboveUsers = await Leaderboard.find({
      languageId,
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek,
      rank: { $lt: userLeaderboard.rank }
    }).sort({ rank: -1 }).limit(2);
    
    const belowUsers = await Leaderboard.find({
      languageId,
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek,
      rank: { $gt: userLeaderboard.rank }
    }).sort({ rank: 1 }).limit(2);
    
    // Lấy thông tin người dùng
    const getUserInfo = async (leaderboardItem) => {
      const user = await User.findById(leaderboardItem.userId);
      return {
        userId: leaderboardItem.userId,
        username: user ? user.username : 'Unknown',
        fullName: user ? user.fullName : 'Unknown',
        avatar: user ? user.avatar : null,
        experienceGained: leaderboardItem.experienceGained,
        rank: leaderboardItem.rank
      };
    };
    
    const aboveUsersInfo = await Promise.all(aboveUsers.map(getUserInfo));
    const belowUsersInfo = await Promise.all(belowUsers.map(getUserInfo));
    
    // Lấy thông tin người dùng hiện tại
    const currentUser = await User.findById(userId);
    
    res.status(200).json({
      weekStartDate: startOfWeek,
      weekEndDate: endOfWeek,
      currentUser: {
        userId,
        username: currentUser.username,
        fullName: currentUser.fullName,
        avatar: currentUser.avatar,
        experienceGained: userLeaderboard.experienceGained,
        rank: userLeaderboard.rank
      },
      aboveUsers: aboveUsersInfo,
      belowUsers: belowUsersInfo
    });
  } catch (error) {
    console.error('Lỗi khi lấy thứ hạng người dùng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy thứ hạng' });
  }
};
