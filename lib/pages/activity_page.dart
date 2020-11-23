import 'package:app_cnpm/models/posts_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_profile.dart';

class ActivityPage extends StatefulWidget {
  // final DocumentReference documentReference;
  // final User user;
  // ActivityPage({this.documentReference, this.user});

  @override
  _ActivityPage createState() => _ActivityPage();
}

class _ActivityPage extends State<ActivityPage> {
  // var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black87,child: ListView.builder(
      itemCount: posts.length,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 16.0),
          child: ListTile(
            title: GestureDetector(
              onTap: () {
                // snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                // Navigator.push(context, MaterialPageRoute(
                //     builder: ((context) => InstaProfileScreen())
                // )) : Navigator.push(context, MaterialPageRoute(
                //     builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                // ));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomProfile(ipost: posts[index])));
              },
              child: Text(
                posts[index].username,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                // snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                // Navigator.push(context, MaterialPageRoute(
                //     builder: ((context) => InstaProfileScreen())
                // )) : Navigator.push(context, MaterialPageRoute(
                //     builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                // ));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomProfile(ipost: posts[index])));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    posts[index].userImage),
                radius: 30.0,
              ),
            ),
            // trailing:
            //     snapshot.data[index].data['ownerUid'] != widget.user.uid
            //         ? buildProfileButton(snapshot.data[index].data['ownerName'])
            //         : null,
          ),
        );
      }),
    ));
  }
}


// class ActivityScreen extends StatefulWidget {
//   final String currentUserId;
//
//   ActivityScreen({this.currentUserId});
//
//   @override
//   _ActivityScreenState createState() => _ActivityScreenState();
// }
//
// class _ActivityScreenState extends State<ActivityScreen> {
//   List<Activity> _activities = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _setupActivities();
//   }
//
//   _setupActivities() async {
//     List<Activity> activities =
//     await DatabaseService.getActivities(widget.currentUserId);
//     if (mounted) {
//       setState(() {
//         _activities = activities;
//       });
//     }
//   }
//
//   _buildActivity(Activity activity) {
//     return FutureBuilder(
//       future: DatabaseService.getUserWithId(activity.fromUserId),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           return SizedBox.shrink();
//         }
//         User user = snapshot.data;
//         return ListTile(
//           leading: CircleAvatar(
//             radius: 20.0,
//             backgroundColor: Colors.grey,
//             backgroundImage: user.profileImageUrl.isEmpty
//                 ? AssetImage('assets/images/user_placeholder.jpg')
//                 : CachedNetworkImageProvider(user.profileImageUrl),
//           ),
//           title: activity.comment != null
//               ? Text('${user.name} commented: "${activity.comment}"')
//               : Text('${user.name} liked your post'),
//           subtitle: Text(
//             DateFormat.yMd().add_jm().format(activity.timestamp.toDate()),
//           ),
//           trailing: CachedNetworkImage(
//             imageUrl: activity.postImageUrl,
//             height: 40.0,
//             width: 40.0,
//             fit: BoxFit.cover,
//           ),
//           onTap: () async {
//             String currentUserId = Provider.of<UserData>(context).currentUserId;
//             Post post = await DatabaseService.getUserPost(
//               currentUserId,
//               activity.postId,
//             );
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CommentsScreen(
//                   post: post,
//                   likeCount: post.likeCount,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Instagram',
//           style: TextStyle(
//             color: Colors.black,
//             fontFamily: 'Billabong',
//             fontSize: 35.0,
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => _setupActivities(),
//         child: ListView.builder(
//           itemCount: _activities.length,
//           itemBuilder: (BuildContext context, int index) {
//             Activity activity = _activities[index];
//             return _buildActivity(activity);
//           },
//         ),
//       ),
//     );
//   }
// }
