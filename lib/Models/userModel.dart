class UserModel
{
  String username;
  int activeMuseum;
  int viewCount;
  List<dynamic> likedUsers;
  int likes;
  String ppLink;
  final String uid;

  UserModel({
    this.username,
    this.activeMuseum,
    this.viewCount,
    this.likedUsers,
    this.likes,
    this.ppLink,
    this.uid
  });
}