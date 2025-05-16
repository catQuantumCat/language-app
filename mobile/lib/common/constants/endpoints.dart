// common/constants/endpoints.dart (bổ sung)
abstract class Endpoints {
  static String baseApi = "https://english-app-backend2.onrender.com/api/";
  

  static String loginShort = "auth/login";

  static String login = "$baseApi/auth/login";
  static String register = "$baseApi/auth/register";
  static String getAvailableLanguages =
      "$baseApi/languages"; // Add available languages endpoint
  static String getUserLanguages =
      "$baseApi/users/languages"; // Get user's languages
  static String addUserLanguage =
      "$baseApi/users/languages"; // Add language to user
      
  // Thêm endpoints mới
  static String getLeaderboard = "${baseApi}leaderboard";
  static String getUserRank = "${baseApi}leaderboard/user";
  static String getUserMistakes = "${baseApi}mistakes/users";
  static String getMistakeDetail = "${baseApi}mistakes/detail";
  // Endpoints cho knowledge feature
  static String getUnits(String languageId) => "${baseApi}languages/$languageId/units";
  static String getLessons(String unitId) => "${baseApi}unit/$unitId/lessons";
  static String getKnowledge(String lessonId) => "${baseApi}lesson/$lessonId/knowledge";
  // Thêm endpoints cho profile
  static String getUserProfile = "${baseApi}auth/me";
  static String getUserRankInfo = "${baseApi}leaderboard/me";
  static String updateUserProfile = "${baseApi}users"; // Sẽ thêm /{userId}/profile khi gọi
  static String uploadImage = "${baseApi}upload";
}

const String loginEndpoint = "/auth/login";
const String registerEndpoint = "/auth/register";
const String availableLanguagesEndpoint = "/languages";
const String userLanguagesEndpoint = "/users/languages";
const String leaderboardEndpoint = "/leaderboard";
const String userRankEndpoint = "/leaderboard/user/{userId}";
const String userMistakesEndpoint = "/mistakes/users/{userId}";
const String mistakeDetailEndpoint = "/mistakes/detail/{mistakeId}";
// Thêm các endpoint constants mới
const String unitsEndpoint = "/languages/{languageId}/units";
const String lessonsEndpoint = "/unit/{unitId}/lessons";
const String knowledgeEndpoint = "/lesson/{lessonId}/knowledge";
// Constants cho endpoints
const String userProfileEndpoint = "/auth/me";
const String userRankInfoEndpoint = "/leaderboard/me";
const String updateUserProfileEndpoint = "/users/{userId}/profile";
