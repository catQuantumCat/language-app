module.exports = {
    testEnvironment: 'node',
    testMatch: ['**/tests/**/*.test.js'],
    collectCoverage: true,
    coverageDirectory: 'coverage',
    collectCoverageFrom: [
      'models/**/*.js',
      'controllers/**/*.js',
      'middlewares/**/*.js',
      '!**/node_modules/**'
    ]
  };
  