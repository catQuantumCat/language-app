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
    const { 
      userId, 
      lessonId, 
      exercises,
      hearts, 
      experienceGained, 
      timeSpent, 
      streak
    } = req.body;

    // Kiểm tra dữ liệu đầu vào
    if (!userId || !lessonId || !exercises || !Array.isArray(exercises)) {
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





// API lấy danh sách câu sai của người dùng (tiếp)
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
      
      const mistakes = await mistakesQuery.exec();
      
      // Lấy thông tin chi tiết cho mỗi lỗi
      const response = await Promise.all(mistakes.map(async (mistake) => {
        const mistakeObj = mistake.toObject();
        mistakeObj.id = mistakeObj._id.toString();
        delete mistakeObj._id;
        
        // Lấy thông tin exercise
        const exercise = await Exercise.findById(mistake.exerciseId);
        
        // Lấy thông tin đáp án đã chọn
        const selectedOption = await ExerciseOption.findById(mistake.selectedOptionId);
        
        // Lấy thông tin đáp án đúng
        const correctOption = await ExerciseOption.findById(mistake.correctOptionId);
        
        // Lấy tất cả các đáp án của bài tập
        const allOptions = await ExerciseOption.find({ exerciseId: mistake.exerciseId });
        
        return {
          ...mistakeObj,
          exercise: exercise ? {
            id: exercise._id.toString(),
            question: exercise.question,
            instruction: exercise.instruction,
            exerciseType: exercise.exerciseType,
            audioUrl: exercise.audioUrl,
            imageUrl: exercise.imageUrl
          } : null,
          selectedOption: selectedOption ? {
            id: selectedOption._id.toString(),
            text: selectedOption.text,
            audioUrl: selectedOption.audioUrl,
            imageUrl: selectedOption.imageUrl
          } : null,
          correctOption: correctOption ? {
            id: correctOption._id.toString(),
            text: correctOption.text,
            audioUrl: correctOption.audioUrl,
            imageUrl: correctOption.imageUrl
          } : null,
          allOptions: allOptions.map(option => ({
            id: option._id.toString(),
            text: option.text,
            isCorrect: option.correct,
            audioUrl: option.audioUrl,
            imageUrl: option.imageUrl
          }))
        };
      }));
      
      res.status(200).json(response);
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
      
      // Lấy thông tin đáp án đã chọn
      const selectedOption = await ExerciseOption.findById(mistake.selectedOptionId);
      
      // Lấy thông tin đáp án đúng
      const correctOption = await ExerciseOption.findById(mistake.correctOptionId);
      
      // Lấy tất cả các đáp án của bài tập
      const allOptions = await ExerciseOption.find({ exerciseId: mistake.exerciseId });
      
      const mistakeObj = mistake.toObject();
      mistakeObj.id = mistakeObj._id.toString();
      delete mistakeObj._id;
      
      res.status(200).json({
        ...mistakeObj,
        exercise: exercise ? {
          id: exercise._id.toString(),
          question: exercise.question,
          instruction: exercise.instruction,
          exerciseType: exercise.exerciseType,
          audioUrl: exercise.audioUrl,
          imageUrl: exercise.imageUrl
        } : null,
        selectedOption: selectedOption ? {
          id: selectedOption._id.toString(),
          text: selectedOption.text,
          audioUrl: selectedOption.audioUrl,
          imageUrl: selectedOption.imageUrl
        } : null,
        correctOption: correctOption ? {
          id: correctOption._id.toString(),
          text: correctOption.text,
          audioUrl: correctOption.audioUrl,
          imageUrl: correctOption.imageUrl
        } : null,
        allOptions: allOptions.map(option => ({
          id: option._id.toString(),
          text: option.text,
          isCorrect: option.correct,
          audioUrl: option.audioUrl,
          imageUrl: option.imageUrl
        }))
      });
    } catch (error) {
      console.error('Lỗi khi lấy chi tiết câu sai:', error);
      res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
    }
  };
  
  // Thêm vào file User_exercise.controller.js

// API làm lại danh sách câu hỏi sai
module.exports.retryMistakes = async (req, res) => {
  try {
    const { userId } = req.params;
    const { languageId, limit } = req.query;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập dữ liệu của người dùng khác' });
    }
    
    // Xây dựng query
    const query = { userId, mastered: false };
    if (languageId) query.languageId = languageId;
    
    // Lấy danh sách lỗi, sắp xếp theo thời gian tạo gần nhất
    let mistakesQuery = UserMistake.find(query)
      .sort({ createdAt: -1 });
    
    if (limit) {
      mistakesQuery = mistakesQuery.limit(parseInt(limit));
    }
    
    const mistakes = await mistakesQuery.exec();
    
    // Lấy thông tin chi tiết cho mỗi lỗi để tạo bài tập ôn tập
    const exercisesFromMistakes = await Promise.all(mistakes.map(async (mistake) => {
      // Lấy thông tin exercise
      const exercise = await Exercise.findById(mistake.exerciseId);
      if (!exercise) return null;
      
      // Lấy tất cả các đáp án của bài tập
      const options = await ExerciseOption.find({ exerciseId: mistake.exerciseId });
      
      // Định dạng lại exercise để trả về
      const exerciseObj = exercise.toObject();
      exerciseObj.id = exerciseObj._id.toString();
      delete exerciseObj._id;
      
      // Xử lý khác nhau tùy theo loại bài tập
      if (exerciseObj.exerciseType === 'sentenceOrder') {
        // Định dạng lại options
        const formattedOptions = options.map(option => {
          const optionObject = option.toObject();
          optionObject.id = optionObject._id.toString();
          delete optionObject._id;
          
          // Lọc các trường null
          Object.keys(optionObject).forEach(key => {
            if (optionObject[key] === null) {
              delete optionObject[key];
            }
          });
          
          return optionObject;
        });
        
        // Thêm sentenceLength vào data
        const data = {
          options: formattedOptions,
          sentenceLength: formattedOptions.length
        };

        return {
          ...exerciseObj,
          data: data,
          mistakeId: mistake._id.toString()
        };
      } 
      else if (exerciseObj.exerciseType === 'translateWritten') {
        if (options.length > 0) {
          // Lấy thông tin từ option đầu tiên
          const option = options[0].toObject();
          
          // Trả về data không bọc trong mảng options
          return {
            ...exerciseObj,
            data: {
              acceptedAnswer: option.acceptedAnswer || [],
              translateWord: option.translateWord || ""
            },
            mistakeId: mistake._id.toString()
          };
        } else {
          return {
            ...exerciseObj,
            data: {
              acceptedAnswer: [],
              translateWord: ""
            },
            mistakeId: mistake._id.toString()
          };
        }
      }
      else {
        // Định dạng lại options
        const formattedOptions = options.map(option => {
          const optionObject = option.toObject();
          optionObject.id = optionObject._id.toString();
          delete optionObject._id;
          
          // Lọc các trường null
          Object.keys(optionObject).forEach(key => {
            if (optionObject[key] === null) {
              delete optionObject[key];
            }
          });
          
          return optionObject;
        });

        return {
          ...exerciseObj,
          data: {
            options: formattedOptions
          },
          mistakeId: mistake._id.toString()
        };
      }
    }));
    
    // Lọc bỏ các exercise null
    const validExercises = exercisesFromMistakes.filter(ex => ex !== null);
    
    res.status(200).json({
      totalExercises: validExercises.length,
      exercises: validExercises
    });
  } catch (error) {
    console.error('Lỗi khi lấy danh sách câu hỏi sai để làm lại:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lấy dữ liệu' });
  }
};

// API lưu kết quả sau khi làm lại các câu hỏi sai
module.exports.saveMistakesResults = async (req, res) => {
  try {
    const { userId } = req.params;
    const { results, timeSpent } = req.body;
    
    // Kiểm tra quyền truy cập
    if (req.user.id !== userId) {
      return res.status(403).json({ message: 'Không có quyền truy cập dữ liệu của người dùng khác' });
    }
    
    // Kiểm tra dữ liệu đầu vào
    if (!results || !Array.isArray(results)) {
      return res.status(400).json({ message: 'Thiếu thông tin kết quả' });
    }
    
    // Tính toán số câu đúng
    const totalExercises = results.length;
    const correctAnswers = results.filter(result => result.isCorrect).length;
    const score = Math.round((correctAnswers / totalExercises) * 100);
    
    // Cập nhật trạng thái cho các câu hỏi sai
    for (const result of results) {
      if (result.mistakeId && result.isCorrect) {
        const mistake = await UserMistake.findById(result.mistakeId);
        if (mistake) {
          mistake.reviewedCount += 1;
          mistake.lastReviewed = new Date();
          
          // Nếu đã xem lại và làm đúng >= 2 lần, đánh dấu là đã thành thạo
          if (mistake.reviewedCount >= 2) {
            mistake.mastered = true;
          }
          
          await mistake.save();
        }
      }
    }
    
    // Cộng kinh nghiệm cho người dùng (cộng ít hơn so với làm bài thường)
    const experienceGained = Math.round((correctAnswers / totalExercises) * 5); // 5 XP cho mỗi bài ôn tập
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
    
    // Cộng kinh nghiệm
    user.experience += experienceGained;
    
    // Cập nhật kinh nghiệm cho ngôn ngữ cụ thể (nếu có)
    if (results.length > 0 && results[0].languageId) {
      const languageId = results[0].languageId;
      const languageIndex = user.languages.findIndex(
        lang => lang.languageId.toString() === languageId
      );
      
      if (languageIndex !== -1) {
        user.languages[languageIndex].experience += experienceGained;
      }
    }
    
    // Cập nhật streak nếu là ngày mới
    const today = new Date().setHours(0, 0, 0, 0);
    const lastActiveDay = new Date(user.lastActive).setHours(0, 0, 0, 0);
    
    if (today > lastActiveDay) {
      user.streak += 1;
    }
    
    user.lastActive = new Date();
    
    await user.save();
    
    res.status(200).json({
      totalExercises,
      correctAnswers,
      score,
      experienceGained,
      message: 'Đã lưu kết quả ôn tập thành công'
    });
  } catch (error) {
    console.error('Lỗi khi lưu kết quả ôn tập:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi khi lưu kết quả' });
  }
};

