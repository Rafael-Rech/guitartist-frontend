enum ELessonType{
  listening("LISTENING"),
  playing("PLAYING"),
  quiz("QUIZ");

  const ELessonType(this.backendDescription);

  final String backendDescription;
}