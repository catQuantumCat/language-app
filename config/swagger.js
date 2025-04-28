const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Language Learning API',
      version: '1.0.0',
      description: 'API documentation for Language Learning Application'
    },
    servers: [
      {
        url: 'http://localhost:3000/api'
      }
    ]
  },
  apis: [
    './routes/*.route.js',
    './routes/**/*.route.js',
    './controllers/*.js',
    './controllers/**/*.js'
  ]
};

const swaggerSpec = swaggerJsdoc(options);
module.exports = swaggerSpec;
