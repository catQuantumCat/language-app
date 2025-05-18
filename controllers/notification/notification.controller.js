const Notification = require('../../models/notification/notification.model');
const ReminderSetting = require('../../models/notification/reminder_setting.model');
const User = require('../../models/user/user.model');

// Tạo thông báo mới
module.exports.createNotification = async (userId, type, title, message, data = {}) => {
  try {
    const notification = new Notification({
      userId,
      type,
      title,
      message,
      data
    });
    
    await notification.save();
    return notification;
  } catch (error) {
    console.error('Lỗi khi tạo thông báo:', error);
    throw error;
  }
};

// Lấy danh sách thông báo của người dùng
module.exports.getUserNotifications = async (req, res) => {
  try {
    const { userId } = req.params;
    const { limit = 20, page = 1, type } = req.query;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập thông báo của người dùng khác' });
    }
    
    // Xây dựng query
    const query = { userId };
    if (type) {
      query.type = type;
    }
    
    // Đếm tổng số thông báo
    const total = await Notification.countDocuments(query);
    
    // Lấy danh sách thông báo, phân trang
    const notifications = await Notification.find(query)
      .sort({ createdAt: -1 })
      .skip((parseInt(page) - 1) * parseInt(limit))
      .limit(parseInt(limit));
    
    // Định dạng kết quả
    const formattedNotifications = notifications.map(notification => {
      const notificationObj = notification.toObject();
      notificationObj.id = notificationObj._id.toString();
      delete notificationObj._id;
      
      return notificationObj;
    });
    
    // Đếm số thông báo chưa đọc
    const unreadCount = await Notification.countDocuments({ userId, isRead: false });
    
    res.status(200).json({
      notifications: formattedNotifications,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(total / parseInt(limit))
      },
      unreadCount
    });
  } catch (error) {
    console.error('Lỗi khi lấy danh sách thông báo:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy danh sách thông báo' });
  }
};

// Đánh dấu thông báo đã đọc
module.exports.markNotificationAsRead = async (req, res) => {
  try {
    const { userId, notificationId } = req.params;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập thông báo của người dùng khác' });
    }
    
    // Tìm thông báo
    const notification = await Notification.findOne({ _id: notificationId, userId });
    if (!notification) {
      return res.status(404).json({ message: 'Không tìm thấy thông báo' });
    }
    
    // Đánh dấu đã đọc
    notification.isRead = true;
    await notification.save();
    
    res.status(200).json({
      id: notification._id.toString(),
      isRead: true,
      message: 'Đã đánh dấu thông báo là đã đọc'
    });
  } catch (error) {
    console.error('Lỗi khi đánh dấu thông báo đã đọc:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi cập nhật thông báo' });
  }
};

// Đánh dấu tất cả thông báo đã đọc
module.exports.markAllNotificationsAsRead = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập thông báo của người dùng khác' });
    }
    
    // Cập nhật tất cả thông báo chưa đọc
    const result = await Notification.updateMany(
      { userId, isRead: false },
      { $set: { isRead: true } }
    );
    
    res.status(200).json({
      updatedCount: result.modifiedCount,
      message: 'Đã đánh dấu tất cả thông báo là đã đọc'
    });
  } catch (error) {
    console.error('Lỗi khi đánh dấu tất cả thông báo đã đọc:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi cập nhật thông báo' });
  }
};

// Xóa thông báo
module.exports.deleteNotification = async (req, res) => {
  try {
    const { userId, notificationId } = req.params;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền xóa thông báo của người dùng khác' });
    }
    
    // Tìm và xóa thông báo
    const notification = await Notification.findOneAndDelete({ _id: notificationId, userId });
    if (!notification) {
      return res.status(404).json({ message: 'Không tìm thấy thông báo' });
    }
    
    res.status(200).json({
      id: notificationId,
      message: 'Đã xóa thông báo thành công'
    });
  } catch (error) {
    console.error('Lỗi khi xóa thông báo:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi xóa thông báo' });
  }
};
