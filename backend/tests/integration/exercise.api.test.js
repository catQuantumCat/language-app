
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');

const Exercise = require('../../models/exercise/exercise.model');
const ExerciseOption = require('../../models/exercise/exercise_option.model');
const exerciseController = require('../../controllers/exercise/exercise.controller');

let mongoServer;
const app = express();
app.use(bodyParser.json());

// Thiết lập route cho kiểm thử
app.get('/api/lesson/:lessonId/exercises', exerciseController.getExercisesByLesson);

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  await mongoose.connect(mongoServer.getUri());
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

describe('Exercise API Integration', () => {
  const lessonId = new mongoose.Types.ObjectId().toString();
  
  beforeEach(async () => {
    await Exercise.deleteMany({});
    await ExerciseOption.deleteMany({});
    
    // Tạo dữ liệu mẫu
    const exercise1 = new Exercise({
      lessonId,
      exerciseType: 'multipleChoice',
      instruction: 'Chọn đáp án đúng',
      question: 'What is the capital of France?',
      order: 1
    });
    await exercise1.save();
    
    // Tạo options cho exercise1
    await ExerciseOption.create([
      {
        exerciseId: exercise1._id.toString(),
        text: 'Paris',
        correct: true,
        order: 1
      },
      {
        exerciseId: exercise1._id.toString(),
        text: 'London',
        correct: false,
        order: 2
      },
      {
        exerciseId: exercise1._id.toString(),
        text: 'Berlin',
        correct: false,
        order: 3
      }
    ]);
    
    // Tạo exercise thứ 2 với loại khác
    const exercise2 = new Exercise({
      lessonId,
      exerciseType: 'translateWritten',
      instruction: 'Dịch câu sau',
      question: 'Hello, how are you?',
      order: 2
    });
    await exercise2.save();
    
    // Tạo option cho exercise2
    await ExerciseOption.create({
      exerciseId: exercise2._id.toString(),
      translateWord: 'Hello, how are you?',
      acceptedAnswer: ['Xin chào, bạn khỏe không?', 'Chào, bạn khỏe không?']
    });
  });

  it('should return exercises with correct format by lessonId', async () => {
    const response = await request(app)
      .get(`/api/lesson/${lessonId}/exercises`)
      .expect(200);
    
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBe(2);
    
    // Kiểm tra exercise đầu tiên (multipleChoice)
    const multipleChoiceExercise = response.body.find(ex => ex.exerciseType === 'multipleChoice');
    expect(multipleChoiceExercise).toBeDefined();
    expect(multipleChoiceExercise.id).toBeDefined();
    expect(multipleChoiceExercise.instruction).toBe('Chọn đáp án đúng');
    expect(multipleChoiceExercise.question).toBe('What is the capital of France?');
    expect(multipleChoiceExercise.data.options.length).toBe(3);
    
    // Kiểm tra có đáp án đúng
    const correctOption = multipleChoiceExercise.data.options.find(opt => opt.correct === true);
    expect(correctOption).toBeDefined();
    expect(correctOption.text).toBe('Paris');
    
    // Kiểm tra exercise thứ hai (translateWritten)
    const translateExercise = response.body.find(ex => ex.exerciseType === 'translateWritten');
    expect(translateExercise).toBeDefined();
    expect(translateExercise.instruction).toBe('Dịch câu sau');
    expect(translateExercise.data.translateWord).toBe('Hello, how are you?');
    expect(translateExercise.data.acceptedAnswer).toBeInstanceOf(Array);
    expect(translateExercise.data.acceptedAnswer.length).toBe(2);
  });

  it('should return empty array for non-existent lessonId', async () => {
    const nonExistentId = new mongoose.Types.ObjectId().toString();
    
    const response = await request(app)
      .get(`/api/lesson/${nonExistentId}/exercises`)
      .expect(200);
    
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBe(0);
  });
});
