import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/club/all_club_model.dart';
import '../models/club/my_club_post.dart';
import '../models/club/my_posts.dart';
import '../models/club/newfeed.dart';
import '../models/club/user_club_joined.dart';
import '../models/club/user_club_not_joined.dart';
import '../models/user/all_car_models.dart';
import '../models/user/all_my_car.dart';
import '../models/sos/all_my_sos_models.dart';
import '../models/user/all_my_tnc_sos_models.dart';
import '../models/user/car_data_calculated.dart';
import '../models/club/club_details.dart';
import '../models/user/current_tnc_sos_models.dart';
import '../models/user/my_car_details.dart';
import '../models/club/my_club_models.dart';
import '../models/sos/my_current_sos_models.dart';
import '../models/user/my_job_models.dart';
import '../models/sos/problem_type.dart';
import '../models/sos/sos_details_models.dart';
import '../models/sos/specific_problem.dart';
import '../models/user/user_profile_model.dart';

MyProfile? resultUserProfile;
AllMyCar? resultAllMyCar;
MyCarDetails? resultMyCarDetails;
MyClub? resultMyClub;
ClubDetailsModel? resultClubDetailsModel;
MyJob? resultMyJob;
MyCurrentSos? resultMyCurrentSOS;
SosDetails? resultSosDetails;
CurrentTncSos? resultCurrentTncSos;
AllMyTncSos? resultAllMyTncSos;
AllMySos? resultAllMySos;
AllCarModel? resultAllCar;
ProblemType? resultProblemType;
SpecificProblem? resultSpecificProblem;
CarDataCal? resultCarDataCal;
UserClubJoined? resultUserClubJoined;
UserClubNotJoined? resultUserClubNotJoined;
ClubPostModel? resultClubPostModel;
MyPosts? resultMyPosts;
AllClubModel? resultAllClubModel;
NewFeedModel? resultNewFeedModel;

const url = "https://api.racroad.com/api";
// const testurl = "https://api-racroad.chabafarm.com/api";

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
  Future<AllMyCar?> getMyCar(String token) async {
    try {
      final response = await http.get(Uri.parse("$url/mycar/all/$token"));
      if (response.statusCode == 200) {
        final itemMyCar = json.decode(response.body);
        resultAllMyCar = AllMyCar.fromJson(itemMyCar);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultAllMyCar;
  }

  // ################################ MyCarDetails #################################
  Future<MyCarDetails?> getMyCarDetails(String carId) async {
    try {
      final response = await http.get(Uri.parse("$url/mycar/detail/$carId"));
      if (response.statusCode == 200) {
        final itemMyCarDetails = json.decode(response.body);
        resultMyCarDetails = MyCarDetails.fromJson(itemMyCarDetails);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyCarDetails;
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
  Future<ClubDetailsModel?> getClubDetailsModel(String clubId, String userId) async {
    try {
      final response =
          await http.get(Uri.parse("$url/club/approve/detail/$clubId/$userId"));
      if (response.statusCode == 200) {
        final itemClubDetailsModel = json.decode(response.body);
        resultClubDetailsModel = ClubDetailsModel.fromJson(itemClubDetailsModel);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultClubDetailsModel;
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
      final response = await http.get(Uri.parse("$url/sos/detail/$sosId"));
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

  // ################################ MyCurrentTncSos #################################
  Future<CurrentTncSos?> getCurrentTncSos(String tncId) async {
    try {
      final response =
          await http.get(Uri.parse("$url/my/tnc/sos/in/progress/$tncId"));
      if (response.statusCode == 200) {
        final itemCurrentTncSos = json.decode(response.body);
        resultCurrentTncSos = CurrentTncSos.fromJson(itemCurrentTncSos);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultCurrentTncSos;
  }

  // ################################ AllMyTncSos #################################
  Future<AllMyTncSos?> getAllMyTncSos(String tncId) async {
    try {
      final response = await http.get(Uri.parse("$url/my/tnc/sos/$tncId"));
      if (response.statusCode == 200) {
        final itemAllMyTncSos = json.decode(response.body);
        resultAllMyTncSos = AllMyTncSos.fromJson(itemAllMyTncSos);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultAllMyTncSos;
  }

  // ################################ AllMySos #################################
  Future<AllMySos?> getAllMySos(String token) async {
    try {
      final response = await http.get(Uri.parse("$url/my/user/sos/$token"));
      if (response.statusCode == 200) {
        final itemAllMySos = json.decode(response.body);
        resultAllMySos = AllMySos.fromJson(itemAllMySos);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultAllMySos;
  }

  // ################################ AllCar #################################
  Future<AllCarModel?> getAllCar() async {
    try {
      final response = await http.get(Uri.parse("$url/car/data"));
      if (response.statusCode == 200) {
        final itemAllCar = json.decode(response.body);
        resultAllCar = AllCarModel.fromJson(itemAllCar);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultAllCar;
  }

  // ################################ ProblemType #################################
  Future<ProblemType?> getProblemType() async {
    try {
      final response = await http.get(Uri.parse("$url/problem/type/all"));
      if (response.statusCode == 200) {
        final itemProblemType = json.decode(response.body);
        resultProblemType = ProblemType.fromJson(itemProblemType);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultProblemType;
  }

  // ################################ SpecificProblem #################################
  Future<SpecificProblem?> getSpecificProblem(String problemTypeId) async {
    try {
      final response = await http
          .get(Uri.parse("$url/problem/in/problem/type/$problemTypeId"));
      if (response.statusCode == 200) {
        final itemSpecificProblem = json.decode(response.body);
        resultSpecificProblem = SpecificProblem.fromJson(itemSpecificProblem);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultSpecificProblem;
  }

  // ################################ Car Data Calculated #################################
  Future<CarDataCal?> getCarDataCal(String carId) async {
    try {
      final response = await http.get(Uri.parse("$url/upgc/cal/$carId"));
      if (response.statusCode == 200) {
        final itemCarDataCal = json.decode(response.body);
        resultCarDataCal = CarDataCal.fromJson(itemCarDataCal);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultCarDataCal;
  }

  // ################################ User Club Joined #################################
  Future<UserClubJoined?> getUserClubJoined(String userId) async {
    try {
      final response = await http.get(Uri.parse("$url/my/club/join/$userId"));
      if (response.statusCode == 200) {
        final itemUserClubJoined = json.decode(response.body);
        resultUserClubJoined = UserClubJoined.fromJson(itemUserClubJoined);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultUserClubJoined;
  }

  // ################################ User Club NOT Joined #################################
  Future<UserClubNotJoined?> getUserClubNotJoined(String userId) async {
    try {
      final response = await http.get(Uri.parse("$url/club/not/join/$userId"));
      if (response.statusCode == 200) {
        final itemUserClubNotJoined = json.decode(response.body);
        resultUserClubNotJoined =
            UserClubNotJoined.fromJson(itemUserClubNotJoined);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultUserClubNotJoined;
  }

  // ################################ My Club Posts #################################
  Future<ClubPostModel?> getClubPostModel(String clubId) async {
    try {
      final response = await http.get(Uri.parse("$url/my/club/post/$clubId"));
      if (response.statusCode == 200) {
        final itemClubPostModel = json.decode(response.body);
        resultClubPostModel = ClubPostModel.fromJson(itemClubPostModel);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultClubPostModel;
  }

  // ################################ My Posts #################################
  Future<MyPosts?> getMyPosts(String userId) async {
    try {
      final response = await http.get(Uri.parse("$url/my/post/$userId"));
      if (response.statusCode == 200) {
        final itemMyPosts = json.decode(response.body);
        resultMyPosts = MyPosts.fromJson(itemMyPosts);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultMyPosts;
  }

  // ################################ My Posts #################################
  Future<NewFeedModel?> getNewFeedModel(String userId) async {
    try {
      final response = await http.get(Uri.parse("$url/post/in/my/club/join/$userId"));
      if (response.statusCode == 200) {
        final itemNewFeedModel = json.decode(response.body);
        resultNewFeedModel = NewFeedModel.fromJson(itemNewFeedModel);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultNewFeedModel;
  }

  // ################################ All Club Model #################################
  Future<AllClubModel?> getAllClubModel() async {
    try {
      final response = await http.get(Uri.parse("$url/club/approve"));
      if (response.statusCode == 200) {
        final itemAllClubModel = json.decode(response.body);
        resultAllClubModel = AllClubModel.fromJson(itemAllClubModel);
      } else {
        throw Exception(jsonDecode(response.body));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return resultAllClubModel;
  }
}
