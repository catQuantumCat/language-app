// common/constants/endpoints.dart (bổ sung)
abstract class Endpoints {
  static String baseApi = "https://english-app-backend2.onrender.com/api/";
  static String getExercises =
      "$baseApi/lesson/61a7f56d9f5f7a001f9d4d01/exercises";

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
}

const String loginEndpoint = "/auth/login";
const String registerEndpoint = "/auth/register";
const String getExercises = "/lesson/61a7f56d9f5f7a001f9d4d01/exercises";
const String availableLanguagesEndpoint = "/languages";
const String userLanguagesEndpoint = "/users/languages";
const String leaderboardEndpoint = "/leaderboard";
const String userRankEndpoint = "/leaderboard/user/{userId}";
const String userMistakesEndpoint = "/mistakes/users/{userId}";
const String mistakeDetailEndpoint = "/mistakes/detail/{mistakeId}";
