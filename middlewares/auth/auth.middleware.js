const jwt = require('jsonwebtoken');
const User = require('../../models/user/user.model');

module.exports.verifyToken = async (req, res, next) => {
  try {
    // Lấy token từ header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Không tìm thấy token xác thực' });
    }

    const token = authHeader.split(' ')[1];
    
    // Xác thực token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Kiểm tra người dùng có tồn tại không
    const user = await User.findById(decoded.id);
    if (!user) {
      return res.status(401).json({ message: 'Người dùng không tồn tại' });
    }
    
    // Lưu thông tin người dùng vào request
    req.user = {
      id: user._id.toString(),
      username: user.username
    };
    
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ message: 'Token không hợp lệ' });
    }
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token đã hết hạn' });
    }
    console.error('Lỗi xác thực:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi xác thực' });
  }
};
