import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/utils/formatters/formatter.dart';

class UserModel {
  // keep those values which dont want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;

  // constructor for usermodel
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  // helper function  to get the full name
  String get fullName => '$firstName $lastName';

  // helper function to format phone number
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  // static function to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  // static function to generate a username from the full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName"; // combine first name and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // add "cwt_" prefix
    return usernameWithPrefix;
  }

  // static function to create an empty user model
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
      );

  // convert model to json structure for starting data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
    };
  }

  //factory method to create a usermodel from a firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
      );
    }else {
      throw StateError('Document does not exist');
    }
  }
}
