class ChallengeOption {
  final int id;
  final int challengeId;
  // int order
  final String text;
  final String? audioUrl;
  final String? imageUrl;
  ChallengeOption(
      {required this.id,
      required this.challengeId,
      required this.text,
      this.imageUrl,
      this.audioUrl});
}

class MultipleChoiceOption extends ChallengeOption {
  final bool correct;

  MultipleChoiceOption(
      {required super.id,
      required super.challengeId,
      required this.correct,
      required super.text,
      super.audioUrl,
      super.imageUrl});
}

enum PairMachingEnum { left, right }

class PairMatchingOption extends ChallengeOption {
  final int pairId;
  final PairMachingEnum column;

  /*
   {
        "audioUrl": null,
        "imageUrl": null,
        "_id": "67c04f36a18b6f59b741ae3a",
        "exerciseId": "67c04ac8a18b6f59b741ae2e",
        "text": "Cow",
        "pairId": 3,
        "column": "left"
      },
  */

  PairMatchingOption(
      {required super.id,
      required super.challengeId,
      required super.text,
      required this.pairId,
      required this.column,
      super.imageUrl,
      super.audioUrl});
}
