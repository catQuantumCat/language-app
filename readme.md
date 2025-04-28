## Lấy unit của người người dùng
http://localhost:3000/api/languages/68022c102f05fe8c6a1166e4/units?userId=680b999b2f05fe8c6a116828
## Dữ liệu trả ra:
{
    "description": "",
    "iconUrl": null,
    "requiredExperience": 0,
    "isActive": true,
    "languageId": "68022c102f05fe8c6a1166e4",
    "title": "One",
    "order": 1,
    "id": "68022fcc2f05fe8c6a1166e9",
    "isUnlocked": true
  },

## Lấy danh sách các lessons
http://localhost:3000/api/unit/68022fcc2f05fe8c6a1166e9/lessons?userId=680b999b2f05fe8c6a116828
## Dữ liệu trả ra:
[
  {
    "description": "",
    "iconUrl": null,
    "experienceReward": 10,
    "requiredHearts": 1,
    "timeLimit": null,
    "isActive": true,
    "unitId": "68022fcc2f05fe8c6a1166e9",
    "title": "What's your name?",
    "order": 1,
    "id": "680230982f05fe8c6a1166ed",
    "progress": {
      "completed": false,
      "score": 0,
      "attempts": 0
    }
  }
]
## Lấy danh sách các user
http://localhost:3000/api/users/680b999b2f05fe8c6a116828
## Dữ liệu trả ra
{
  "avatar": null,
  "hearts": 5,
  "experience": 0,
  "streak": 0,
  "username": "tungbachtran",
  "email": "tung2982004@gmail.com",
  "fullName": "Trần Bách Tùng",
  "languages": [
    {
      "level": 0,
      "experience": 0,
      "_id": "680ba2bf7bb897557bb07b5f",
      "languageId": "68022c102f05fe8c6a1166e4"
    }
  ],
  "lastActive": "2025-04-25T14:57:03.465Z",
  "id": "680b999b2f05fe8c6a116828",
  "stats": {
    "completedLessons": 0,
    "totalExperience": 0,
    "totalTimeSpent": 0,
    "mistakeCount": 0,
    "masteredMistakeCount": 0
  }
}

## Lấy ra các exercises từ 1 lesson
http://localhost:3000/api/lesson/680230982f05fe8c6a1166ed/exercises
