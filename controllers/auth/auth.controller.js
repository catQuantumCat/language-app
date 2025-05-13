const User = require('../../models/user/user.model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Đăng ký tài khoản mới


module.exports.register = async (req, res) => {
  try {
    const { username, email, password, fullName } = req.body;

    // Kiểm tra dữ liệu đầu vào
    if (!username || !email || !password) {
      return res.status(400).json({ message: 'Thiếu thông tin cần thiết' });
    }

    // Kiểm tra username đã tồn tại chưa
    const existingUsername = await User.findOne({ username });
    if (existingUsername) {
      return res.status(409).json({ message: 'Tên đăng nhập đã tồn tại' });
    }

    // Kiểm tra email đã tồn tại chưa
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return res.status(409).json({ message: 'Email đã được sử dụng' });
    }

    // Mã hóa mật khẩu
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Tạo người dùng mới
    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      fullName: fullName || username,
      hearts: 5,
      experience: 0,
      streak: 0,
      lastActive: new Date(),
      languages: []
    });

    await newUser.save();

    // Tạo token
    const token = jwt.sign(
      { id: newUser._id, username: newUser.username },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    // Trả về thông tin người dùng (không bao gồm mật khẩu)
    const userResponse = {
      id: newUser._id.toString(),
      username: newUser.username,
      email: newUser.email,
      fullName: newUser.fullName,
      avatar: newUser.avatar,
      hearts: newUser.hearts,
      experience: newUser.experience,
      streak: newUser.streak,
      languages: newUser.languages,
      token
    };

    res.status(201).json(userResponse);
  } catch (error) {
    console.error('Lỗi khi đăng ký tài khoản:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi đăng ký tài khoản' });
  }
};



// Đăng nhập
module.exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Kiểm tra dữ liệu đầu vào
    if (!username || !password) {
      return res.status(400).json({ message: 'Thiếu thông tin đăng nhập' });
    }

    // Tìm người dùng theo username hoặc email
    const user = await User.findOne({
      $or: [{ username }, { email: username }]
    });

    if (!user) {
      return res.status(401).json({ message: 'Tên đăng nhập hoặc mật khẩu không chính xác' });
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Tên đăng nhập hoặc mật khẩu không chính xác' });
    }

    // Cập nhật lastActive
    user.lastActive = new Date();
    await user.save();

    // Tạo token
    const token = jwt.sign(
      { id: user._id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    // Trả về thông tin người dùng (không bao gồm mật khẩu)
    const userResponse = {
      id: user._id.toString(),
      username: user.username,
      email: user.email,
      fullName: user.fullName,
      avatar: user.avatar,
      hearts: user.hearts,
      experience: user.experience,
      streak: user.streak,
      languages: user.languages,
      token
    };

    res.status(200).json(userResponse);
  } catch (error) {
    console.error('Lỗi khi đăng nhập:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi đăng nhập' });
  }
};



// Lấy thông tin người dùng hiện tại
module.exports.getCurrentUser = async (req, res) => {
  try {
    const userId = req.user.id;
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
    
    // Cập nhật lastActive
    user.lastActive = new Date();
    await user.save();
    
    // Trả về thông tin người dùng (không bao gồm mật khẩu)
    const userResponse = {
      id: user._id.toString(),
      username: user.username,
      email: user.email,
      fullName: user.fullName,
      avatar: user.avatar,
      hearts: user.hearts,
      experience: user.experience,
      streak: user.streak,
      languages: user.languages.map(lang => ({
        languageId: lang.languageId.toString(),
        languageFlag: lang.languageFlag,
        lessonOrder: lang.lessonOrder,
        order: lang.order,
      
      }))
    };
    
    res.status(200).json(userResponse);
  } catch (error) {
    console.error('Lỗi khi lấy thông tin người dùng:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy thông tin người dùng' });
  }
};
