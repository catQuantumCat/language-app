const Knowledge = require('../../models/knowledge/knowledge.model');
const Lesson = require('../../models/lesson/lesson.model');


module.exports.getLessonKnowledge = async (req, res) => {
  try {
    const { lessonId } = req.params;
   
    
    // Kiểm tra lesson có tồn tại không
    console.log('Truy vấn knowledge với lessonId:', lessonId);
    const lesson = await Lesson.findById(lessonId);
    if (!lesson) {
      return res.status(404).json({ message: 'Không tìm thấy bài học' });
    }
    
    // Lấy thông tin knowledge của lesson
    const knowledge = await Knowledge.findOne({ lessonId });
    
    if (!knowledge) {
      return res.status(404).json({ message: 'Không tìm thấy nội dung kiến thức cho bài học này' });
    }
    
    
    
    // Chuẩn bị dữ liệu trả về
    const response = {
      lessonId: lessonId,
      lessonTitle: lesson.title,
      lessonOrder: lesson.order,
      vocabulary: knowledge.vocabulary.sort((a, b) => a.order - b.order),
      grammar: knowledge.grammar.sort((a, b) => a.order - b.order),
      
    };
    
    
    
    res.status(200).json(response);
  } catch (error) {
    console.error('Lỗi khi lấy kiến thức bài học:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};

