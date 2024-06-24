

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class User {
  final int index;
  final String titel;
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String pictureSmall;
  final String pictureLarge;
  final String gender;
  final String dob;

  const User({
    required this.index,
    required this.titel,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.pictureSmall,
    required this.pictureLarge,
    required this.gender,
    required this.dob
  });

  String fullName(){
    return capitalize(this.titel) + ". " + capitalize(this.fname) + " " + capitalize(this.lname);
  }
}