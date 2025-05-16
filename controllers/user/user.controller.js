const User = require('../../models/user/user.model');
const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const cloudinary = require('cloudinary').v2;
const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');

// Cấu hình Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Cấu hình storage cho multer sử dụng Cloudinary
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'user_avatars',
    allowed_formats: ['jpg', 'jpeg', 'png', 'gif'],
    transformation: [{ width: 500, height: 500, crop: 'limit' }]
  }
});

// Cấu hình multer
const upload = multer({ storage: storage });

// Middleware xử lý upload ảnh
module.exports.uploadAvatar = upload.single('avatar');





// Hàm cập nhật thông tin người dùng
module.exports.updateUserProfile = async (req, res) => {
  try {
    const { userId } = req.params;
    const { fullName, email, password } = req.body;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền cập nhật thông tin người dùng khác' });
    }
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
    
    // Kiểm tra email đã tồn tại chưa nếu có yêu cầu thay đổi email
    if (email && email !== user.email) {
      const existingEmail = await User.findOne({ email });
      if (existingEmail) {
        return res.status(409).json({ message: 'Email đã được sử dụng' });
      }
      user.email = email;
    }
    
    // Cập nhật thông tin
    if (fullName) user.fullName = fullName;
    
    // Cập nhật avatar nếu có file được tải lên
    if (req.file) {
      // Nếu đã có avatar cũ, xóa ảnh cũ trên Cloudinary
      if (user.avatar && user.avatar.includes('cloudinary')) {
        const publicId = user.avatar.split('/').pop().split('.')[0];
        await cloudinary.uploader.destroy(`user_avatars/${publicId}`);
      }
      
      // Lưu đường dẫn mới
      user.avatar = req.file.path;
    }
    
    // Cập nhật mật khẩu nếu có
    if (password) {
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(password, salt);
    }
    
    await user.save();
    
    // Trả về thông tin người dùng đã cập nhật
    const userObj = user.toObject();
    userObj.id = userObj._id.toString();
    delete userObj._id;
    delete userObj.password;
    
    res.status(200).json({
      ...userObj,
      message: 'Đã cập nhật thông tin cá nhân thành công'
    });
  } catch (error) {
    console.error('Lỗi khi cập nhật thông tin cá nhân:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi cập nhật thông tin' });
  }
};



module.exports.updateUserLanguage = async (req, res) => {
  try {
    const { userId } = req.params;
    const { languages } = req.body;

    // Kiểm tra xem có dữ liệu cập nhật không
    if (!languages || !Array.isArray(languages) || languages.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Cần cung cấp mảng languages với ít nhất một phần tử'
      });
    }

    // Tìm người dùng
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }

    // Xử lý từng phần tử trong mảng languages
    for (const item of languages) {
      const { languageId, lessonId } = item;

      if (!languageId) {
        continue; // Bỏ qua phần tử không có languageId
      }

      // Lấy thông tin về ngôn ngữ để lấy flagUrl
      const language = await mongoose.model('languages').findById(languageId);
      if (!language) {
        continue; // Bỏ qua nếu không tìm thấy ngôn ngữ
      }

      // Biến để lưu lessonOrder
      let lessonOrder = 0; // Mặc định lessonOrder là 0
      if (lessonId) {
        const lesson = await mongoose.model('lessons').findById(lessonId);
        if (lesson) {
          lessonOrder = lesson.order;
        }
      }

      // Cập nhật hoặc thêm mới ngôn ngữ vào mảng languages
      const existingLanguageIndex = user.languages.findIndex(
        lang => lang.languageId === languageId
      );

      const order = item.order || 1; // Mặc định order là 1

      if (existingLanguageIndex !== -1) {
        // Cập nhật ngôn ngữ đã tồn tại
        if (lessonId) {
          user.languages[existingLanguageIndex].lessonId = lessonId;
          user.languages[existingLanguageIndex].lessonOrder = lessonOrder;
        }
        user.languages[existingLanguageIndex].order = order;
        user.languages[existingLanguageIndex].languageFlag = language.flagUrl;
      } else {
        // Thêm ngôn ngữ mới vào mảng
        user.languages.push({
          languageId,
          languageFlag: language.flagUrl,
          lessonOrder: lessonOrder,
          order: order
        });
      }
    }

    // Lưu thay đổi
    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Cập nhật thông tin ngôn ngữ thành công',
      data: {
        languages: user.languages
      }
    });
  } catch (error) {
    console.error('Lỗi khi cập nhật thông tin ngôn ngữ:', error);
    return res.status(500).json({
      success: false,
      message: 'Đã xảy ra lỗi khi cập nhật thông tin ngôn ngữ',
      error: error.message
    });
  }
};
