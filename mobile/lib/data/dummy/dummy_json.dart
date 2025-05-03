const dummyOptionJson = '''
{
"audioUrl": null,
"imageUrl": null,
"column": null,
"id": "67c020135efc275fccb04057",
"exerciseId": "67c01b025efc275fccb04048",
"correct": true,
"text": "Ha Noi"
}
''';

const dummyJsonData = '''
[
  {
    "id": "67c06529a18b6f59b741ae51",
    "exerciseType": "multipleChoice",
    "question": "Listen and choose correct answer",
    "order": 6,
    "audioUrl": "https://english-app-backend-seven.vercel.app/audio/demo.mp3",

    "data": {
      "options": [
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c06899980fa7b3f0e6a305",
          "exerciseId": "67c06529a18b6f59b741ae51",
          "correct": true,
          "text": "Music"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c06899980fa7b3f0e6a306",
          "exerciseId": "67c06529a18b6f59b741ae51",
          "correct": false,
          "text": "Poem"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c06899980fa7b3f0e6a307",
          "exerciseId": "67c06529a18b6f59b741ae51",
          "correct": false,
          "text": "Rap"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c06899980fa7b3f0e6a308",
          "exerciseId": "67c06529a18b6f59b741ae51",
          "correct": false,
          "text": "Love"
        }
      ]
    }
  },
  {
    "id": "67c01b025efc275fccb04048",
    "exerciseType": "multipleChoice",
    "question": "What is the capital of Viet Nam?",
    "order": 1,
    "data": {
      "options": [
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c020135efc275fccb04057",
          "exerciseId": "67c01b025efc275fccb04048",
          "correct": true,
          "text": "Ha Noi"
        }
      ]
    }
  },
  {
    "id": "67c04ac8a18b6f59b741ae2e",
    "exerciseType": "pairMatching",
    "question": "Nối các cặp từ sau cho đúng nghĩa",
    "order": 2,
    "data": {
      "options": [
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae38",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Dog",
          "pairId": 1,
          "column": "left"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae39",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Cat",
          "pairId": 2,
          "column": "left"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae3a",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Cow",
          "pairId": 3,
          "column": "left"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae3b",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Mèo",
          "pairId": 2,
          "column": "right"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae3c",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Chó",
          "pairId": 1,
          "column": "right"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "id": "67c04f36a18b6f59b741ae3d",
          "exerciseId": "67c04ac8a18b6f59b741ae2e",
          "text": "Bò",
          "pairId": 3,
          "column": "right"
        }
      ]
    }
  },
  {
    "id": "67c05083a18b6f59b741ae3f",
    "exerciseType": "sentenceOrder",
    "question": "Sắp xếp các từ sau theo đúng trật tự",
    "order": 3,
    "data": {
      "optionLength": 2,
      "options": [
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c05154a18b6f59b741ae41",
          "exerciseId": "67c05083a18b6f59b741ae3f",
          "text": "What",
          "order": 1
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c05154a18b6f59b741ae42",
          "exerciseId": "67c05083a18b6f59b741ae3f",
          "text": "name?",
          "order": 4
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c05154a18b6f59b741ae43",
          "exerciseId": "67c05083a18b6f59b741ae3f",
          "text": "is",
          "order": 2
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c05154a18b6f59b741ae44",
          "exerciseId": "67c05083a18b6f59b741ae3f",
          "text": "your",
          "order": 3
        }
      ]
    }
  },
  {
    "id": "67c05341a18b6f59b741ae47",
    "exerciseType": "translateWritten",
    "question": "Dịch câu trên ra tiếng Việt",
    "order": 4,
    "data": {
      "acceptedAnswer": ["Xin chào", "Chào"]
    }
  },
  {
    "id": "67c06529a18b6f59b741ae50",
    "exerciseType": "multipleChoice",
    "question": "Who is this?",
    "order": 5,
    "imageUrl": "https://english-app-backend-seven.vercel.app/images/huy.jpg",
    "data": {
      "options": [
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c06638a18b6f59b741ae53",
          "exerciseId": "67c06529a18b6f59b741ae50",
          "correct": true,
          "text": "Huy"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c067c3980fa7b3f0e6a301",
          "exerciseId": "67c06529a18b6f59b741ae50",
          "correct": true,
          "text": "Huy"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c067c3980fa7b3f0e6a302",
          "exerciseId": "67c06529a18b6f59b741ae50",
          "correct": false,
          "text": "Tung"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c067c3980fa7b3f0e6a303",
          "exerciseId": "67c06529a18b6f59b741ae50",
          "correct": false,
          "text": "Quan"
        },
        {
          "audioUrl": null,
          "imageUrl": null,
          "column": null,
          "id": "67c067c3980fa7b3f0e6a304",
          "exerciseId": "67c06529a18b6f59b741ae50",
          "correct": false,
          "text": "Khoa"
        }
      ]
    }
  }
]

''';
