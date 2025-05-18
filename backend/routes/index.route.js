const exerciseRoutes = require('./exercise/exercise.route');
const languageRoutes = require('./language/language.route');
const unitRoutes = require('./unit/unit.route');
const lessonRoutes = require('./lesson/lesson.route');
const userRoutes = require('./user/user.route');
const authRoutes = require('./auth/auth.route');
const leaderboardRoutes = require('./leaderboard/leaderboard.route');
const notificationRoutes = require('./notification/notification.route');
const mistakeRoutes = require('./mistake/mistake.route');
const knowledgeRoutes = require('./knowledge/knowledge.route');

module.exports = (app) => {
 
  app.use('/api/lesson/:lessonId/exercises', exerciseRoutes);
  app.use('/api/lesson/:lessonId/knowledge', knowledgeRoutes);
  app.use('/api/languages', languageRoutes);
  app.use('/api/languages/:languageId/units', unitRoutes);
  app.use('/api/unit/:unitId/lessons', lessonRoutes);
  app.use('/api/users', userRoutes);
  app.use('/api/auth', authRoutes);
  app.use('/api/leaderboard', leaderboardRoutes);
  app.use('/api/notifications', notificationRoutes);
  app.use('/api/mistakes', mistakeRoutes);
};
