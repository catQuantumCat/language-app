abstract class Endpoints {
  static String baseApi = "https://english-app-backend2.onrender.com/api/";
  static String getExercises =
      "$baseApi/lesson/680230982f05fe8c6a1166ed/exercises";
}

const String loginEndpoint = "/auth/login";
const String registerEndpoint = "/auth/register";
const String getExercises = "lesson/680230982f05fe8c6a1166ed/exercises";
const String availableLanguagesEndpoint =
    "/languages"; // Add constant for available languages
const String userLanguagesEndpoint =
    "/users/languages"; // Add constant for user languages
