enum DecorationType { icon, frame, name_color }

class Decorations {
  Decorations({required this.type, required this.detail});

  final DecorationType type;
  final String detail;

  factory Decorations.fromJson(Map<String, dynamic> json) {
    print("Parsing decoration JSON: $json");

    return Decorations(
      type: _parseDecorationType(json['type'] as String),
      detail: json['detail'] as String,
    );
  }

  static DecorationType _parseDecorationType(String json) {
    switch (json) {
      case 'icon':
        return DecorationType.icon;
      case 'frame':
        return DecorationType.frame;
      case 'name_color':
        return DecorationType.name_color;
      default:
        throw ArgumentError("Unknown decoration type: $json");
    }
  }
}
