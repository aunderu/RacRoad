import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rac_road/models/user_profile_model.dart';

UserProfile? resultUserProfile;

const url = "https://api-racroad.chabafarm.com/api";


// ################################ UserProfile #################################
Future<UserProfile?> getUserProfile() async {
  final response = await http.get(
    Uri.parse("$url/my/profile/14"),
  );
  if (response.statusCode == 200) {
    final itemUserProfile = json.decode(response.body);
    resultUserProfile = UserProfile.fromJson(itemUserProfile);
  } else {
    throw Exception(jsonDecode(response.body));
  }
  return resultUserProfile;
}