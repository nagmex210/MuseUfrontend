import 'package:flutter/material.dart';
import 'package:muse_u/blocs/UserBloc.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:muse_u/helpers/apiRequestMaker.dart';
import 'package:muse_u/blocs/MuseumBloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class SearchBar extends StatefulWidget {
  final UserCubit userCubit;
  final MuseumsCubit museumsCubit;

  const SearchBar({@required this.userCubit,@required this.museumsCubit});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: PaginatedSearchBar<SearchItem>(
            minSearchLength: 4,
            hintText: 'Search',
            emptyBuilder: (context) {
              return ;
            },
            placeholderBuilder: (context) {
              return ;
            },
            onSearch: ({
              @required pageIndex,
              @required pageSize,
              @required searchQuery,
            }) async {
              print(searchQuery);
              List<SearchItem> foundAndConverted = [];
              if(searchQuery != null || searchQuery != "")
              {
                List<dynamic> found = await apiHandler.getFilteredUsers(searchQuery);
                foundAndConverted = found.map((name) =>
                    SearchItem(title: name ,isLiked: widget.userCubit.state.likedUsers.contains(name),inGuestList: widget.museumsCubit.state[0].guestList.contains(name))
                ).toList();
                setState(() {});
              }
              return foundAndConverted;
            },
            itemBuilder: (
                context, {
                  @required item,
                  @required index,
                }) {
              return  Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color(0xff000000),
                          height: 1.5384615384615385,
                          fontWeight: FontWeight.w600),
                      textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(width: 10),
                    item.isLiked ? InkWell(onTap: ()async{
                      await widget.userCubit.removeLikeFromUser(widget.userCubit.state.uid, item.title);
                      item.isLiked = false;
                      setState(() {});
                      print(widget.userCubit.state.likedUsers);
                      EasyLoading.showSuccess("Removed from favorites");
                    },onLongPress: ()async{
                      if(item.inGuestList)
                      {
                        await widget.museumsCubit.removeFromGuestList(widget.userCubit.state.uid, item.title);
                        item.inGuestList = false;
                        setState(() {});
                        print(widget.museumsCubit.state[0].guestList);
                        EasyLoading.showSuccess("Removed From Guest List");
                      }
                      else
                      {
                        await widget.museumsCubit.addToGuestList(widget.userCubit.state.uid, item.title);
                        item.inGuestList = true;
                        setState(() {});
                        print(widget.museumsCubit.state[0].guestList);
                        EasyLoading.showSuccess("Added to Guest List");
                      }
                    },child: Icon(Icons.favorite,size: 30,))
                        :
                    InkWell(
                        onTap:()async{
                      await widget.userCubit.likeUser(widget.userCubit.state.uid, item.title);
                      item.isLiked = true;
                      setState(() {});
                      print(widget.userCubit.state.likedUsers);
                      EasyLoading.showSuccess("Added to favorites");
                    },
                        onLongPress: ()async{
                          if(item.inGuestList)
                          {
                            await widget.museumsCubit.removeFromGuestList(widget.userCubit.state.uid, item.title);
                            item.inGuestList = false;
                            setState(() {});
                            print(widget.museumsCubit.state[0].guestList);
                            EasyLoading.showSuccess("Removed From Guest List");
                          }
                          else
                          {
                            await widget.museumsCubit.addToGuestList(widget.userCubit.state.uid, item.title);
                            item.inGuestList = true;
                            setState(() {});
                            print(widget.museumsCubit.state[0].guestList);
                            EasyLoading.showSuccess("Added to Guest List");
                          }
                        },
                        child: Container(
                      width: 10,
                      height: 10,
                      color: Colors.black,
                    ))
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
    );
  }
}

class SearchItem {
  final String title;
  bool isLiked;
  bool inGuestList;

  SearchItem({
    @required this.title,
    @required this.isLiked,
    @required this.inGuestList
  });
}
