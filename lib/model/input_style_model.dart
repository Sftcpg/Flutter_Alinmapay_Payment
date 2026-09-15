class InputStyleModel {
  final String? backgroundColor;
  final String? borderColor;
  final double? borderWidth;
  final double? cornerRadius;

  const InputStyleModel({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.cornerRadius,
  });

  Map<String, dynamic> toMap() {
    return {
      "backgroundColor": backgroundColor,
      "borderColor": borderColor,
      "borderWidth": borderWidth,
      "cornerRadius": cornerRadius,
    };
  }
}