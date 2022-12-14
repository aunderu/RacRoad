import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rac_road/models/club_details.dart';
import 'package:rac_road/models/my_current_sos_models.dart';
import 'package:rac_road/models/my_job_models.dart';
import 'package:rac_road/models/sos_details_models.dart';

import '../models/my_car_models.dart';
import '../models/my_club_models.dart';
import '../models/user_profile_model.dart';

MyProfile? resultUserProfile;
MyCar? resultMyCar;
MyClub? resultMyClub;
ClubDetails? resultClubDetails;
MyJob? resultMyJob;
MyCurrentSos? resultMyCurrentSOS;
SosDetails? resultSosDetails;

const url = "https://api.racroad.com/api";
const testurl = "https://api-racroad.chabafarm.com/api";

class RemoteService {
  // ################################ UserProfile #################################
  Future<MyProfile?> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$url/my/profile/$token"),
      );
      if (response.statusCode == 200) {
        final itemUserProfile = json.decode(response.body);
        resultUserProfile = MyProfile.fromJson(itemUserProfile);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultUserProfile;
  }

  // ################################ MyCar #################################
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
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyCar;
  }

  // ################################ MyClub #################################
  Future<MyClub?> getMyClub(String token) async {
    try {
      final response = await http.get(Uri.parse("$url/my/club/$token"));
      if (response.statusCode == 200) {
        final itemMyClub = json.decode(response.body);
        resultMyClub = MyClub.fromJson(itemMyClub);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyClub;
  }

  // ################################ ClubDetails #################################
  Future<ClubDetails?> getClubDetails(String clubId) async {
    try {
      final response =
          await http.get(Uri.parse("$url/club/approve/detail/$clubId"));
      if (response.statusCode == 200) {
        final itemClubDetails = json.decode(response.body);
        resultClubDetails = ClubDetails.fromJson(itemClubDetails);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultClubDetails;
  }

  // ################################ MyClub #################################
  Future<MyJob?> getMyJob(String token) async {
    try {
      final response = await http.get(Uri.parse("$url/my/technician/$token"));
      if (response.statusCode == 200) {
        final itemMyJob = json.decode(response.body);
        resultMyJob = MyJob.fromJson(itemMyJob);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyJob;
  }

  // ################################ MyCurrentSOS #################################
  Future<MyCurrentSos?> getMyCurrentSOS(String token) async {
    try {
      final response =
          await http.get(Uri.parse("$url/my/sos/in/progress/$token"));
      if (response.statusCode == 200) {
        final itemMyCurrentSOS = json.decode(response.body);
        resultMyCurrentSOS = MyCurrentSos.fromJson(itemMyCurrentSOS);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyCurrentSOS;
  }

  // ################################ SosDetails #################################
  Future<SosDetails?> getSosDetails(String sosId) async {
    try {
      final response =
          await http.get(Uri.parse("$url/sos/detail/$sosId"));
      if (response.statusCode == 200) {
        final itemSosDetails = json.decode(response.body);
        resultSosDetails = SosDetails.fromJson(itemSosDetails);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultSosDetails;
  }
}
