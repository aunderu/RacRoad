import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/my_car_models.dart';
import '../models/user_profile_model.dart';

UserProfile? resultUserProfile;
MyCar? resultMyCar;

const url = "https://api.racroad.com/api";
const testurl = "https://api-racroad.chabafarm.com/api";

class RemoteService {
  // ################################ UserProfile #################################
  Future<UserProfile?> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$url/my/profile/$token"),
      );
      if (response.statusCode == 200) {
        final itemUserProfile = json.decode(response.body);
        resultUserProfile = UserProfile.fromJson(itemUserProfile);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return resultUserProfile;
  }

  Future<MyCar?> getMyCar(String token) async {
    try {
      final response = await http.get(Uri.parse("$url/mycar/all/$token"));
      if (response.statusCode == 200) {
        final itemMyCar = json.decode(response.body);
        resultMyCar = MyCar.fromJson(itemMyCar);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return resultMyCar;
  }
}
