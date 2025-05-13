const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const User = require('../../models/user/user.model');

let mongoServer;

beforeAll(async () => {
  // Khởi tạo MongoMemoryServer
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  
  // Kết nối mongoose với server trong bộ nhớ
  await mongoose.connect(mongoUri);
  
  // Tạo collection và index
  await mongoose.connection.createCollection('users');
  await mongoose.connection.collection('users').createIndex({ email: 1 }, { unique: true });
  await mongoose.connection.collection('users').createIndex({ username: 1 }, { unique: true });
}, 10000); // Tăng timeout lên 10 giây

beforeEach(async () => {
  await User.deleteMany({});
});

afterAll(async () => {
  await mongoose.disconnect();
  if (mongoServer) {
    await mongoServer.stop();
  }
});

describe('User Model', () => {
  it('should create a user successfully', async () => {
    const userData = {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password123',
      fullName: 'Test User',
      hearts: 5,
      experience: 0,
      streak: 0
    };
    
    const user = new User(userData);
    const savedUser = await user.save();
    
    expect(savedUser._id).toBeDefined();
    expect(savedUser.username).toBe(userData.username);
    expect(savedUser.email).toBe(userData.email);
    expect(savedUser.fullName).toBe(userData.fullName);
  });

  it('should require username, email and password', async () => {
    const userWithoutRequiredFields = new User({});
    
    let error;
    try {
      await userWithoutRequiredFields.save();
    } catch (e) {
      error = e;
    }
    
    expect(error).toBeDefined();
    expect(error.errors.username).toBeDefined();
    expect(error.errors.email).toBeDefined();
    expect(error.errors.password).toBeDefined();
  });

  it('should not allow duplicate username or email', async () => {
    // Tạo user đầu tiên
    const user = new User({
      username: 'uniqueuser',
      email: 'unique@example.com',
      password: 'password123'
    });
    await user.save();
    
    // Tạo user với username trùng lặp
    const duplicateUsername = new User({
      username: 'uniqueuser',  // Username trùng lặp
      email: 'different@example.com',
      password: 'password123'
    });
    
    // Tạo user với email trùng lặp
    const duplicateEmail = new User({
      username: 'differentuser',
      email: 'unique@example.com',  // Email trùng lặp
      password: 'password123'
    });
  
    // Kiểm tra xem việc lưu có gây ra lỗi không
    await expect(duplicateUsername.save()).rejects.toThrow();
    await expect(duplicateEmail.save()).rejects.toThrow();
  });
});
