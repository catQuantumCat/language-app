
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const User = require('../../models/user/user.model');
const authMiddleware = require('../../middlewares/auth/auth.middleware');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  await mongoose.connect(mongoServer.getUri());
  process.env.JWT_SECRET = 'test_secret_key';
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

describe('Auth Middleware', () => {
  let mockUser;
  
  beforeEach(async () => {
    await User.deleteMany({});
    
    // Tạo user cho kiểm thử
    mockUser = new User({
      username: 'testmiddleware',
      email: 'test@middleware.com',
      password: 'password123'
    });
    await mockUser.save();
  });

  it('should pass with valid token', async () => {
    // Tạo token hợp lệ
    const token = jwt.sign(
      { id: mockUser._id.toString(), username: mockUser.username },
      process.env.JWT_SECRET
    );
    
    const req = {
      headers: {
        authorization: `Bearer ${token}`
      }
    };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    const next = jest.fn();
    
    await authMiddleware.verifyToken(req, res, next);
    
    expect(next).toHaveBeenCalled();
    expect(req.user).toBeDefined();
    expect(req.user.id).toBe(mockUser._id.toString());
    expect(req.user.username).toBe(mockUser.username);
  });

  it('should return 401 with invalid token', async () => {
    const req = {
      headers: {
        authorization: 'Bearer invalidtoken'
      }
    };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    const next = jest.fn();
    
    await authMiddleware.verifyToken(req, res, next);
    
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      message: expect.stringContaining('không hợp lệ')
    }));
    expect(next).not.toHaveBeenCalled();
  });

  it('should return 401 with missing token', async () => {
    const req = {
      headers: {}
    };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    const next = jest.fn();
    
    await authMiddleware.verifyToken(req, res, next);
    
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      message: expect.stringContaining('Không tìm thấy token')
    }));
    expect(next).not.toHaveBeenCalled();
  });
});
