class Guest {
  String? id;
  String name;
  String address;
  String imagePath;
  String activity;
  String date;
  String? photoUrl; // Added photoUrl field

  Guest(
      {this.id,
      required this.name,
      required this.address,
      required this.imagePath,
      required this.activity,
      required this.date,
      this.photoUrl}); // Updated constructor to include photoUrl

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      imagePath: map['imagePath'],
      activity: map['activity'],
      date: map['date'],
      photoUrl: map['photoUrl'], // Added mapping for photoUrl
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'imagePath': imagePath,
      'activity': activity,
      'date': date,
      'photoUrl': photoUrl, // Added mapping for photoUrl
    };
  }
}
