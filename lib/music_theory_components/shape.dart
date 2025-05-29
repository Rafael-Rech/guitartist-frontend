enum Shape {
  c(
    4,
    3,
    [0, 3, 4, 5, 6],
    [
      [4, 3, 5, 4],
      [4, 4, 4],
      [4, 3, 4],
      [4, 3, 8, 2],
      [3, 4, 4]
    ]
  ),
  a(
    4,
    0,
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    // List.generate(10, (i) => i),
    [
      [8, 5, 4, 3],
      [8, 5, 3, 4],
      [7, 6, 3, 4],
      [9, 4, 4],
      [8, 4, 5, 3],
      [8, 3, 7, 3],
      [8, 4, 5, 4],
      [8, 3, 5, 4],
      [8, 5],
      [8, 5, 2, 5],
    ],
  ),
  g(
    5,
    3,
    [0, 3, 6, 7],
    [
      [4, 3, 4, 8, 4],
      [9, 4, 3],
      [12, 4, 4],
      [11, 5, 4]
    ],
  ),
  e(
    5,
    0,
    [0, 1, 3, 5, 6, 7, 8],
    [
      [8, 5, 4, 3, 5],
      [8, 5, 3, 4, 5],
      [9, 4, 4, 3],
      [8, 3, 7, 3, 5],
      [8, 4, 4, 4, 5],
      [8, 3, 5, 4, 5],
      [8, 5],
    ],
  ),
  d(
    3,
    0,
    [0, 1, 4, 5, 6, 7, 8, 9],
    [
      [8, 5, 4],
      [8, 5, 3],
      [8, 4, 5],
      [8, 3, 7],
      [8, 4, 4],
      [8, 3, 5],
      [8, 5],
      [8, 5, 2],
    ],
  );

  const Shape(
    this.startingString,
    this.minimalStartingFret,
    this.possibleChords,
    this.intervalsUsed,
  );

  /// The string where a chord in this shape can start
  final int startingString;

  /// The first fret where a chord in this shape can start
  final int minimalStartingFret;

  /// The indexes of the chord types that can be built with this shape
  final List<int> possibleChords;

  /// The indexes of the intervals used for building a type of chord
  final List<List<int>> intervalsUsed;
}
