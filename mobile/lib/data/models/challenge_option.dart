class ChallengeOption {
  int id;
  int challengeId;
  bool correct;
  // int order
  String text;
  String? audioUrl;
  String? imageUrl;
  ChallengeOption(
      {required this.id,
      required this.challengeId,
      required this.correct,
      required this.text,
      this.imageUrl,
      this.audioUrl});
}
