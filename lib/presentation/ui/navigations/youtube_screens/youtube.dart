import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridge_to_feast/Apis/youtube_player_api.dart';
import 'package:fridge_to_feast/logic/cubit/youtube_player/youtube_player_cubit.dart';
import 'package:fridge_to_feast/presentation/ui/navigations/youtube_screens/youtube_player.dart';
import 'package:google_fonts/google_fonts.dart';

class Youtube extends StatelessWidget {
   Youtube({
    super.key,
  });

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Form(
                      child: TextFormField(
                        controller: _searchController,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "How to make cake ?",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                            context.read<YoutubeCubit>().getSearchedVideosFromYoutube(title: _searchController.text);
                            }, icon: const Icon(Icons.search))),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
            BlocBuilder<YoutubeCubit, YoutubeSearchingState>(
              builder: (context, state) {
                if(state is YoutubeSearchingLoadedState){
                  return _suggestedSearches(context,state);
                }else if(state is YoutubeSearchingLoadingState){
                  return const Center(
                    child:CircularProgressIndicator(color: Colors.deepPurple,strokeWidth: 2.8,),
                  );
                }
                else if(state is YoutubeSearchingErrorState){
                  return Center(child: Text("${state.message.toString()}"),);
                }else if(state is YoutubeSearchingEmptyState){
                  return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10,),
                          Text("Search some videos",style: GoogleFonts.alexandria(fontSize: 15),),
                        ],
                      ),
                    ],
                  );
                }else{
                  return Text("Ooops Something went wrong !!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _suggestedSearches(BuildContext context, YoutubeSearchingLoadedState state,) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: state.data.items.length,
        itemBuilder: (context, index) {
          final videoId = state.data.items[index].id!.videoId;
          final thumbnail = state.data.items[index].snippet!.thumbnails!.thumbnailsDefault!.url;
          final videoTitle = state.data.items[index].snippet!.title;
          return GestureDetector(
            onTap: () async {
              // final obj = YoutubePlayerApi();
              // await obj.getVideoSearch("how to make cake");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyYoutubePlayer(youtubeVideoId: "youtubeVideoId")));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 100,
                  width: 160,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5)),
                  child: Image.network(thumbnail.toString(),fit: BoxFit.cover,),
                ),
                const SizedBox(
                  width: 10,
                ),
                 Flexible(
                  child: Text(
                   videoTitle.toString(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
