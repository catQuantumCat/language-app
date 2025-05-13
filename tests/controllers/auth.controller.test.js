
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const request = require('supertest');
const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const User = require('../../models/user/user.model');
const authController = require('../../controllers/auth/auth.controller');
const bcrypt = require('bcrypt');

let mongoServer;
const app = express();
app.use(bodyParser.json());

// Thiết lập route cho kiểm thử
app.post('/api/auth/register', authController.register);
app.post('/api/auth/login', authController.login);

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  await mongoose.connect(mongoServer.getUri());
  process.env.JWT_SECRET = 'test_secret_key';
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

describe('Auth Controller', () => {
  beforeEach(async () => {
    await User.deleteMany({});
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      const userData = {
        username: 'newuser',
        email: 'newuser@example.com',
        password: 'password123',
        fullName: 'New User'
      };
      
      const response = await request(app)
        .post('/api/auth/register')
        .send(userData)
        .expect(201);
      
      expect(response.body.id).toBeDefined();
      expect(response.body.username).toBe(userData.username);
      expect(response.body.email).toBe(userData.email);
      expect(response.body.fullName).toBe(userData.fullName);
      expect(response.body.token).toBeDefined();
      
      // Kiểm tra password đã được mã hóa
      const savedUser = await User.findById(response.body.id);
      expect(savedUser.password).not.toBe(userData.password);
    });

    it('should return 409 if username already exists', async () => {
      // Tạo user trước
      await new User({
        username: 'existinguser',
        email: 'different@example.com',
        password: 'password123'
      }).save();
      
      const response = await request(app)
        .post('/api/auth/register')
        .send({
          username: 'existinguser',
          email: 'new@example.com',
          password: 'password123'
        })
        .expect(409);
      
      expect(response.body.message).toContain('Tên đăng nhập đã tồn tại');
    });
  });

  describe('login', () => {
    beforeEach(async () => {
      // Tạo user cho kiểm thử đăng nhập
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash('password123', salt);
      
      await new User({
        username: 'testlogin',
        email: 'testlogin@example.com',
        password: hashedPassword,
        fullName: 'Test Login'
      }).save();
    });

    it('should login successfully with correct credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          username: 'testlogin',
          password: 'password123'
        })
        .expect(200);
      
      expect(response.body.token).toBeDefined();
      expect(response.body.username).toBe('testlogin');
      
      // Kiểm tra token hợp lệ
      const decoded = jwt.verify(response.body.token, process.env.JWT_SECRET);
      expect(decoded.username).toBe('testlogin');
    });

    it('should return 401 with incorrect password', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          username: 'testlogin',
          password: 'wrongpassword'
        })
        .expect(401);
      
      expect(response.body.message).toContain('không chính xác');
    });
  });
});
