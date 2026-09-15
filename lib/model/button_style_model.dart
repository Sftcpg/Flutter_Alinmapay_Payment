class ButtonStyleModel {
  final String? backgroundColor;
  final String? textColor;
  final String? borderColor;
  final int? borderWidth;
  final int? cornerRadius;
  final int? height;

  const ButtonStyleModel({
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.cornerRadius,
    this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      "backgroundColor": backgroundColor,
      "textColor": textColor,
      "borderColor": borderColor,
      "borderWidth": borderWidth,
      "cornerRadius": cornerRadius,
      "height": height,
    };
  }
}