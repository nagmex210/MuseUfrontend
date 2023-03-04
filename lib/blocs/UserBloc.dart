import 'package:muse_u/helpers/apiRequestMaker.dart';
import 'package:bloc/bloc.dart';
import 'package:muse_u/Models/userModel.dart';

class UserCubit extends Cubit<UserModel>
{
  UserCubit() : super(UserModel(
    username: "",
    activeMuseum: 0,
    likedUsers: [],
    likes: 0,
    viewCount: 0,
    ppLink: "",
    uid: ""
  ));

  Future<void> getUser(uid) async{
    try
    {
      await apiHandler.getUserInfo(uid).then((value) {
        var user = UserModel(
          username: value["username"],
          activeMuseum: value["activeMuseum"],
          likedUsers: value["likedUsers"],
          likes: value["likes"],
          viewCount: value["viewCount"],
          ppLink: value["ppLink"],
          uid: value["uid"]
        );
        emit(user);
      });
    }
    catch(e)
    {
      print(e);
    }
  }


  //likesUser
  Future<void> likeUser(String uid,String likedUserUsername)async{
   bool anyError = await apiHandler.likeUser(uid: uid, likedUserUsername: likedUserUsername);
    if (!anyError)
    {
      var nLikedUsers = state.likedUsers;
      nLikedUsers.add(likedUserUsername);
      final updatedUser = UserModel(
          username: state.username,
          activeMuseum: state.activeMuseum,
          likedUsers: nLikedUsers,
          likes: state.likes,
          ppLink: state.ppLink,
          viewCount: state.viewCount,
          uid: state.uid
      );
      emit(updatedUser);
    }
  }

  Future<void> removeLikeFromUser(String uid,String likedUserUsername)async{
    bool anyError = await apiHandler.removeLikeFromUser(uid: uid, likedUserUsername: likedUserUsername);
    if (!anyError)
    {
      var nLikedUsers = state.likedUsers;
      nLikedUsers.remove(likedUserUsername);
      final updatedUser = UserModel(
          username: state.username,
          activeMuseum: state.activeMuseum,
          likedUsers: nLikedUsers,
          likes: state.likes,
          ppLink: state.ppLink,
          viewCount: state.viewCount,
          uid: state.uid
      );
      emit(updatedUser);
    }
  }



  Future<void> updateLikes(int nLikes){
    final updatedUser = UserModel(
        username: state.username,
        activeMuseum: state.activeMuseum,
        likedUsers: state.likedUsers,
        likes: nLikes,
        ppLink: state.ppLink,
        viewCount: state.viewCount,
        uid: state.uid
    );
    emit(updatedUser);
  }

  Future<void> updateProfilePicture()async{
    bool anyError = await apiHandler.updateProfilePicture(uid: state.uid);
    if(!anyError)
    {
      final updatedUser = UserModel(
          username: state.username,
          activeMuseum: state.activeMuseum,
          likedUsers: state.likedUsers,
          likes: state.likes,
          ppLink: "https://firebasestorage.googleapis.com/v0/b/museu-2440a.appspot.com/o/profilePictures%2F${state.uid}.png?alt=media",
          viewCount: state.viewCount,
          uid: state.uid
      );
      emit(updatedUser);
    }
  }


}