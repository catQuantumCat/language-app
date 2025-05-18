const mongoose = require('mongoose');
const UserExerciseResult = require('../../models/user/user_exercise_result.model');
const UserLessonProgress = require('../../models/user/user_lesson_progress.model');
const UserMistake = require('../../models/user/user_mistake.model');
const Exercise = require('../../models/exercise/exercise.model');
const ExerciseOption = require('../../models/exercise/exercise_option.model');
const Lesson = require('../../models/lesson/lesson.model');
const Unit = require('../../models/unit/unit.model');
const User = require('../../models/user/user.model');
const leaderboardController = require('../leaderboard/leaderboard.controller');
// API lưu kết quả một bài tập


// API lưu kết quả sau khi hoàn thành bài học
module.exports.saveLessonResults = async (req, res) => {
  try {
    const { unitId } = req.params;
    const { 
      userId, 
      
      lessonId, 
      exercises,
      hearts, 
      experienceGained, 
      timeSpent, 
      streak
    } = req.body;

    console.log("req.params:", req.params); // Kiểm tra tham số
    console.log("req.body:", req.body); // Kiểm tra body
    
   
    console.log("unitId from params:", unitId); // Kiểm tra unitId

    // Kiểm tra dữ liệu đầu vào
    if (!userId ||!unitId || !lessonId ) {
      return res.status(400).json({ 
        success: false, 
        message: 'Thiếu thông tin bắt buộc hoặc định dạng exercises không hợp lệ' 
      });
    }

    // Kiểm tra từng phần tử trong mảng exercises
    if(exercises.length > 0) {
      for (const exercise of exercises) {
        if (!exercise.exerciseId) {
          return res.status(400).json({
            success: false,
            message: 'Mỗi bài tập phải có exerciseId'
          });
        }
      }
    }

    // 2. Cập nhật thông tin người dùng (tim, XP, streak)
    const user = await User.findById(userId);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }

    // Cập nhật tim, XP và streak của người dùng
    user.hearts = hearts;
    user.experience = (user.experience || 0) + experienceGained;
    user.streak = streak;
    
    await user.save();

    // 1. Tìm hoặc tạo mới tiến trình bài học
    let lessonProgress = await UserLessonProgress.findOne({ userId, lessonId });
    
    if (!lessonProgress) {
      // Nếu không tìm thấy, tạo mới
      lessonProgress = new UserLessonProgress({
        userId,
        unitId,
        lessonId,
        exercises: [], // Khởi tạo mảng rỗng
        hearts,
        experienceGained: (experienceGained || 0),
        timeSpent,
        streak
      });
    } else {
      // Nếu tìm thấy, cập nhật các thông tin khác
      lessonProgress.hearts = hearts;
      lessonProgress.experienceGained = (experienceGained || 0);
      lessonProgress.timeSpent = timeSpent;
      lessonProgress.streak = streak;
    }

    // Thêm các bài tập mới vào mảng exercises
    for (const exercise of exercises) {
      // Kiểm tra xem bài tập đã tồn tại trong mảng chưa
      const existingIndex = lessonProgress.exercises.findIndex(
        e => e.exerciseId === exercise.exerciseId
      );

      if (existingIndex === -1) {
        // Nếu chưa tồn tại, thêm mới vào mảng
        lessonProgress.exercises.push({
          exerciseId: exercise.exerciseId
        });
      }
      // Không cần cập nhật nếu đã tồn tại vì chỉ có exerciseId
    }

    // Lưu tiến trình bài học
    await lessonProgress.save();

    // Lưu lỗi sai cho mỗi bài tập
    const savedMistakes = [];
    for (const exercise of exercises) {
      try {
        const mistake = new UserMistake({
          userId,
          unitId,
          lessonId,
          exerciseId: exercise.exerciseId,
          timestamp: new Date()
        });
        
        await mistake.save();
        savedMistakes.push(mistake);
      } catch (exerciseError) {
        console.error(`Lỗi khi xử lý bài tập ${exercise.exerciseId}:`, exerciseError);
        // Tiếp tục với bài tập tiếp theo
      }
    }

    return res.status(200).json({
      success: true,
      message: 'Đã lưu kết quả bài học thành công',
      data: {
        lessonProgress,
        mistakes: savedMistakes,
        updatedUser: {
          hearts: user.hearts,
          experience: user.experience,
          streak: user.streak
        }
      }
    });
    
  } catch (error) {
    console.error('Lỗi khi lưu kết quả bài học:', error);
    return res.status(500).json({
      success: false,
      message: 'Đã xảy ra lỗi khi lưu kết quả bài học',
      error: error.message
    });
  }
};





// API lấy danh sách câu sai của người dùng (đã sửa)
module.exports.getUserMistakes = async (req, res) => {
  try {
    const { userId } = req.params;
    const { languageId, unitId, lessonId, limit } = req.query;
    
    const query = { userId };
    
    if (languageId) query.languageId = languageId;
    if (unitId) query.unitId = unitId;
    if (lessonId) query.lessonId = lessonId;
    
    // Lấy danh sách lỗi, sắp xếp theo thời gian tạo gần nhất
    let mistakesQuery = UserMistake.find(query)
      .sort({ createdAt: -1 });
    
    if (limit) {
      mistakesQuery = mistakesQuery.limit(parseInt(limit));
    }
    
    const allMistakes = await mistakesQuery.exec();
    
    // Lọc ra các mistake có exerciseId duy nhất (lấy cái gần đây nhất)
    const uniqueExerciseIds = new Set();
    const uniqueMistakes = [];
    
    for (const mistake of allMistakes) {
      if (!uniqueExerciseIds.has(mistake.exerciseId)) {
        uniqueExerciseIds.add(mistake.exerciseId);
        uniqueMistakes.push(mistake);
      }
    }
    
    // Lấy thông tin chi tiết cho mỗi lỗi
    const mistakesWithDetails = await Promise.all(uniqueMistakes.map(async (mistake) => {
      const mistakeObj = mistake.toObject();
      mistakeObj.id = mistakeObj._id.toString();
      delete mistakeObj._id;
      
      // Lấy thông tin unit và order
      const unit = await mongoose.model('units').findById(mistake.unitId);
      
      // Lấy thông tin lesson và order
      const lesson = await mongoose.model('lessons').findById(mistake.lessonId);
      
      // Lấy thông tin exercise
      const exercise = await Exercise.findById(mistake.exerciseId);
      
      return {
        id: mistakeObj.id,
        exerciseId: mistake.exerciseId,
        unitOrder: unit ? unit.order : null,
        unitName: unit ? unit.title : null,
        lessonOrder: lesson ? lesson.order : null,
        lessonName: lesson ? lesson.title : null,
        instruction: exercise ? exercise.instruction : null,
        question: exercise ? exercise.question : null,
        createdAt: mistakeObj.createdAt
      };
    }));
    
    // Sắp xếp kết quả theo unitOrder, lessonOrder
    mistakesWithDetails.sort((a, b) => {
      // Sắp xếp theo unit order
      if (a.unitOrder !== b.unitOrder) {
        return (a.unitOrder || 0) - (b.unitOrder || 0);
      }
      
      // Nếu cùng unit, sắp xếp theo lesson order
      return (a.lessonOrder || 0) - (b.lessonOrder || 0);
    });
    
    res.status(200).json(mistakesWithDetails);
  } catch (error) {
    console.error('Lỗi khi lấy danh sách câu sai:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};

  
  
 // API xem chi tiết một câu sai
module.exports.getMistakeDetail = async (req, res) => {
  try {
    const { mistakeId } = req.params;
    
    const mistake = await UserMistake.findById(mistakeId);
    if (!mistake) {
      return res.status(404).json({ message: 'Không tìm thấy câu sai' });
    }
    
    // Lấy thông tin exercise
    const exercise = await Exercise.findById(mistake.exerciseId);
    if (!exercise) {
      return res.status(404).json({ message: 'Không tìm thấy bài tập' });
    }
    
    
    
   
    
    // Lấy tất cả các đáp án của bài tập
    const allOptions = await ExerciseOption.find({ exerciseId: mistake.exerciseId });
    
    // Lấy thông tin unit
    const unit = await mongoose.model('units').findById(mistake.unitId);
    
    // Lấy thông tin lesson
    const lesson = await mongoose.model('lessons').findById(mistake.lessonId);
    
    const mistakeObj = mistake.toObject();
    mistakeObj.id = mistakeObj._id.toString();
    delete mistakeObj._id;
    
    // Xử lý khác nhau tùy theo loại bài tập
    let exerciseData = {};
    
    if (exercise.exerciseType === 'sentenceOrder') {
      // Định dạng lại options cho sentenceOrder
      exerciseData = {
        options: allOptions.map(option => ({
          id: option._id.toString(),
          text: option.text,
          order: option.order,
          audioUrl: option.audioUrl,
          imageUrl: option.imageUrl
        })),
        sentenceLength: allOptions.length
      };
    } 
    else if (exercise.exerciseType === 'translateWritten') {
      // Định dạng cho translateWritten
      const option = allOptions.length > 0 ? allOptions[0] : null;
      exerciseData = {
        acceptedAnswer: option ? option.acceptedAnswer || [] : [],
        translateWord: option ? option.translateWord || "" : ""
      };
    }
    else {
      // Định dạng cho các loại bài tập khác
      exerciseData = {
        options: allOptions.map(option => ({
          id: option._id.toString(),
          text: option.text,
          isCorrect: option.correct,
          audioUrl: option.audioUrl,
          imageUrl: option.imageUrl
        }))
      };
    }
    
    res.status(200).json({
      id: mistakeObj.id,
      unitOrder: unit ? unit.order : null,
      unitName: unit ? unit.name : null,
      lessonOrder: lesson ? lesson.order : null,
      lessonName: lesson ? lesson.name : null,
      exercise: {
        id: exercise._id.toString(),
        question: exercise.question,
        instruction: exercise.instruction,
        exerciseType: exercise.exerciseType,
        audioUrl: exercise.audioUrl,
        imageUrl: exercise.imageUrl,
        data: exerciseData
      },
      
      createdAt: mistakeObj.createdAt
    });
  } catch (error) {
    console.error('Lỗi khi lấy chi tiết câu sai:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};

 



