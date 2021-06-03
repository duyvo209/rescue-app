class Problem {
  String problemId;
  String name;
  List<String> services = [];

  Problem({this.problemId, this.name, this.services});

  factory Problem.fromFireStore(Map<String, dynamic> json) {
    return Problem(
      problemId: json['problemId'],
      name: json['name'],
      services: (json['service'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'problemId': problemId,
      'name': name,
      'service': services,
    };
  }
}
