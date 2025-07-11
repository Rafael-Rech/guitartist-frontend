class Option {
  Option(this._isCorrect, this._text);
  final bool _isCorrect;
  final String _text;

  String get text => _text;
  bool get isCorrect => _isCorrect;

  @override
  String toString() => "Option: $_text - ${_isCorrect ? 'v' : 'x'}";
}
