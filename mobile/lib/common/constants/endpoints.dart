abstract class Endpoints {
  static String baseApi = "https://english-app-backend2.onrender.com/api/";
  static String getExercises =
      "$baseApi/lesson/680230982f05fe8c6a1166ed/exercises";

  static String loginShort = "auth/login";

  static String login = "$baseApi/auth/login";
  static String register = "$baseApi/auth/register";
}

const String loginEndpoint = "/auth/login";
const String registerEndpoint = "/auth/register";
const String getExercises = "lesson/680230982f05fe8c6a1166ed/exercises";
