const ReminderSetting = require('../../models/notification/reminder_setting.model');
const User = require('../../models/user/user.model');
const notificationController = require('./notification.controller');

// Lấy cài đặt nhắc nhở của người dùng
module.exports.getReminderSettings = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập cài đặt của người dùng khác' });
    }
    
    // Tìm cài đặt nhắc nhở
    let reminderSetting = await ReminderSetting.findOne({ userId });
    
    // Nếu chưa có, tạo mới với cài đặt mặc định
    if (!reminderSetting) {
      reminderSetting = new ReminderSetting({ userId });
      await reminderSetting.save();
    }
    
    const settingObj = reminderSetting.toObject();
    settingObj.id = settingObj._id.toString();
    delete settingObj._id;
    
    res.status(200).json(settingObj);
  } catch (error) {
    console.error('Lỗi khi lấy cài đặt nhắc nhở:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy cài đặt nhắc nhở' });
  }
};

// Cập nhật cài đặt nhắc nhở
module.exports.updateReminderSettings = async (req, res) => {
  try {
    const { userId } = req.params;
    const { isEnabled, reminderTime, reminderDays } = req.body;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền cập nhật cài đặt của người dùng khác' });
    }
    
    // Tìm cài đặt nhắc nhở
    let reminderSetting = await ReminderSetting.findOne({ userId });
    
    // Nếu chưa có, tạo mới
    if (!reminderSetting) {
      reminderSetting = new ReminderSetting({ userId });
    }
    
    // Cập nhật cài đặt
    if (isEnabled !== undefined) reminderSetting.isEnabled = isEnabled;
    if (reminderTime) {
      // Kiểm tra định dạng thời gian HH:MM
      const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/;
      if (!timeRegex.test(reminderTime)) {
        return res.status(400).json({ message: 'Định dạng thời gian không hợp lệ. Sử dụng định dạng HH:MM' });
      }
      reminderSetting.reminderTime = reminderTime;
    }
    if (reminderDays && Array.isArray(reminderDays)) {
      // Kiểm tra các giá trị ngày hợp lệ (0-6)
      const isValidDays = reminderDays.every(day => Number.isInteger(day) && day >= 0 && day <= 6);
      if (!isValidDays) {
        return res.status(400).json({ message: 'Giá trị ngày không hợp lệ. Sử dụng số từ 0-6 (0: Chủ Nhật, 1-6: Thứ Hai - Thứ Bảy)' });
      }
      reminderSetting.reminderDays = reminderDays;
    }
    
    await reminderSetting.save();
    
    const settingObj = reminderSetting.toObject();
    settingObj.id = settingObj._id.toString();
    delete settingObj._id;
    
    res.status(200).json({
      ...settingObj,
      message: 'Đã cập nhật cài đặt nhắc nhở thành công'
    });
  } catch (error) {
    console.error('Lỗi khi cập nhật cài đặt nhắc nhở:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi cập nhật cài đặt nhắc nhở' });
  }
};

// Kiểm tra và gửi thông báo nhắc nhở (chạy theo lịch)
module.exports.checkAndSendReminders = async () => {
  try {
    console.log('Bắt đầu kiểm tra và gửi thông báo nhắc nhở...');
    
    const now = new Date();
    const currentHour = now.getHours();
    const currentMinute = now.getMinutes();
    const currentDay = now.getDay(); // 0: Sunday, 1: Monday, ..., 6: Saturday
    
    // Định dạng thời gian hiện tại thành HH:MM
    const currentTime = `${currentHour.toString().padStart(2, '0')}:${currentMinute.toString().padStart(2, '0')}`;
    
    // Tìm tất cả người dùng có cài đặt nhắc nhở vào thời điểm hiện tại
    const reminderSettings = await ReminderSetting.find({
      isEnabled: true,
      reminderTime: currentTime,
      reminderDays: currentDay
    });
    
    console.log(`Tìm thấy ${reminderSettings.length} người dùng cần gửi nhắc nhở`);
    
    // Gửi thông báo cho từng người dùng
    for (const setting of reminderSettings) {
      // Kiểm tra xem đã gửi thông báo hôm nay chưa
      const today = new Date().setHours(0, 0, 0, 0);
      if (setting.lastReminderSent && new Date(setting.lastReminderSent).setHours(0, 0, 0, 0) === today) {
        console.log(`Đã gửi nhắc nhở cho người dùng ${setting.userId} hôm nay rồi`);
        continue;
      }
      
      // Lấy thông tin người dùng
      const user = await User.findById(setting.userId);
      if (!user) {
        console.log(`Không tìm thấy người dùng ${setting.userId}`);
        continue;
      }
      
      // Kiểm tra người dùng đã học trong ngày chưa
      const lastActiveDay = new Date(user.lastActive).setHours(0, 0, 0, 0);
      if (lastActiveDay === today) {
        console.log(`Người dùng ${user.username} đã học trong ngày hôm nay`);
        continue;
      }
      
      // Tạo thông báo nhắc nhở
      let title = 'Đã đến giờ học rồi!';
      let message = 'Hãy dành ít phút để học ngay hôm nay và duy trì streak của bạn!';
      
      // Nếu có streak, thêm thông tin
      if (user.streak > 0) {
        message = `Bạn đang có streak ${user.streak} ngày liên tiếp. Hãy học ngay để duy trì thành tích!`;
      }
      
      await notificationController.createNotification(
        setting.userId,
        'reminder',
        title,
        message,
        { streak: user.streak }
      );
      
      // Cập nhật thời gian gửi nhắc nhở gần nhất
      setting.lastReminderSent = new Date();
      await setting.save();
      
      console.log(`Đã gửi nhắc nhở cho người dùng ${user.username}`);
    }
    
    console.log('Hoàn thành kiểm tra và gửi thông báo nhắc nhở');
  } catch (error) {
    console.error('Lỗi khi kiểm tra và gửi thông báo nhắc nhở:', error);
  }
};

// Kiểm tra và gửi cảnh báo mất streak (chạy vào cuối ngày)
module.exports.checkAndSendStreakWarnings = async () => {
  try {
    console.log('Bắt đầu kiểm tra và gửi cảnh báo mất streak...');
    
    const now = new Date();
    const today = now.setHours(0, 0, 0, 0);
    
    // Tìm tất cả người dùng có streak > 0 và chưa học trong ngày hôm nay
    const users = await User.find({
      streak: { $gt: 0 },
      lastActive: { $lt: new Date(today) }
    });
    
    console.log(`Tìm thấy ${users.length} người dùng có nguy cơ mất streak`);
    
    // Gửi thông báo cho từng người dùng
    for (const user of users) {
      // Kiểm tra xem người dùng có bật thông báo không
      const reminderSetting = await ReminderSetting.findOne({ userId: user._id });
      if (!reminderSetting || !reminderSetting.isEnabled) {
        console.log(`Người dùng ${user.username} đã tắt thông báo`);
        continue;
      }
      
      // Tạo thông báo cảnh báo
      const title = 'Nguy cơ mất streak!';
      const message = `Streak ${user.streak} ngày của bạn sắp bị mất. Hãy học ngay hôm nay để duy trì thành tích!`;
      
      await notificationController.createNotification(
        user._id.toString(),
        'streak',
        title,
        message,
        { streak: user.streak }
      );
      
      console.log(`Đã gửi cảnh báo mất streak cho người dùng ${user.username}`);
    }
    
    console.log('Hoàn thành kiểm tra và gửi cảnh báo mất streak');
  } catch (error) {
    console.error('Lỗi khi kiểm tra và gửi cảnh báo mất streak:', error);
  }
};
