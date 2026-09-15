class SDKTextStyleModel {
  final int? textSize;
  final bool? bold;
  final String? textColor;

  const SDKTextStyleModel({
    this.textSize,
    this.bold,
    this.textColor,
  });

  Map<String, dynamic> toMap() {
    return {
      "textSize": textSize,
      "bold": bold,
      "textColor": textColor,
    };
  }
}