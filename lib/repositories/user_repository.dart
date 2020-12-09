import 'dart:convert';
import 'serveroperations.dart';

class UserRepository {
  bool isLogined = false;

  //CustomCacheManager customCacheManager = CustomCacheManager();

  UserRepository() {}

  Future<String> registerUser(
      String lastName, String firstName, String email, String password) async {
    final response = await ServerOperation().postDataToServer(
        'http://192.168.1.7:3000/users/signup',
        jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password
        }));

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['success'] == true) {
      return "true";
    } else
      return  jsonDecode(response.body)['error']['message'];
  }

  Future<String> checkLoginCredentials(String email, String password) async {
    String url = 'http://192.168.1.7:3000/users/signin';

    final response = await ServerOperation().postDataToServer(
      url,
      jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['success'] == true) {
      isLogined = true;
      return "true";
    }
    return jsonDecode(response.body)['error']['message'];
  }

// Future<bool> checkIfUserExists(User user) async {
//   String firstName = user.firstName,
//       lastName = user.lastName,
//       nickName = user.nickName,
//       email = user.email,
//       password = user.password;
//
//   String url =
//       "https://bismarck.sdsu.edu/api/instapost-upload/newuser?firstname=$firstName&lastname=$lastName&nickname=$nickName&email=$email&password=$password";
//   final response = await ServerOperation().getDataFromServer(url);
//
//   if (response.statusCode == 200) {
//     return true;
//   }
//
//   return false;
// }

// Future<bool> checkIfNickNameIsTaken(String nickName) async {
//   String url =
//       " https://bismarck.sdsu.edu/api/instapost-query/nickname-exists?nickname=$nickName";
//   final response = await ServerOperation().getDataFromServer(url);
//
//   if (response.statusCode == 200 &&
//       jsonDecode(response.body)["result"] == true) {
//     return true;
//   } else
//     return false;
// }
//
// Future<bool> checkIfEmailIsTaken(String email) async {
//   String url =
//       "https://bismarck.sdsu.edu/api/instapost-query/email-exists?email=$email";
//   final response = await ServerOperation().getDataFromServer(url);
//   if (response.statusCode == 200 &&
//       jsonDecode(response.body)["result"] == true) {
//     return true;
//   } else
//     return false;
// }
//
// Future<List<String>> getAllNickNames() async {
//   if (await ServerOperation().checkConnection()) {
//     String url = "https://bismarck.sdsu.edu/api/instapost-query/nicknames";
//     final response = await ServerOperation().getDataFromServer(url);
//     if (response.statusCode == 200)
//       customCacheManager.writeDataToCache(
//           'nicknames.json', response.body.toString());
//     return List.from(jsonDecode(response.body)["nicknames"]);
//   } else {
//     String response =
//         await customCacheManager.readDataFromCache('nicknames.json');
//     return List.from(jsonDecode(response)["nicknames"]);
//   }
// }

// Future<int> getPendingPostsForSpecificUser(
//     String user, String password) async {
//   if (await ServerOperation().checkConnection()) {
//     List<Map<String, dynamic>> pendingUploads =
//     await DatabaseHelper.instance.queryForAnEmail(user);
//     if (pendingUploads.length > 0)
//       return await PostOperations()
//           .uploadPendingPost(pendingUploads, password);
//   }
//   return 0;
// }
}
