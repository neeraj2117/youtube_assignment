import 'package:flutter/material.dart';
import 'package:youtube/app/routes/app_routes.dart';
import 'package:youtube/models/channel_model.dart';
import 'package:youtube/models/video_model.dart';
import 'package:youtube/screens/video_screen.dart';
import 'package:youtube/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Channel _channel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    try {
      Channel channel = await APIService.instance
          .fetchChannel(channelId: 'UCj_6F_cHsixl59M3Gjv3uTA');
      setState(() {
        _channel = channel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(_channel.profilePictureUrl ?? ''),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _channel.title ?? '',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1.0),
                Text(
                  '${_channel.subscriberCount ?? '0'} subscribers',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoScreen(id: video.id),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: Image.network(
                video.thumbnailUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    video.title ?? '',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    setState(() {
      _isLoading = true;
    });
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId ?? '');
    List<Video> allVideos = _channel.videos!..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/youtube-logo.png',
          height: 35.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileRoute);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : _channel != null
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading &&
                        _channel.videos!.length !=
                            int.parse(_channel.videoCount ?? '0') &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _channel.videos!.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _buildProfileInfo();
                      }
                      Video video = _channel.videos![index - 1];
                      return _buildVideo(video);
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
    );
  }
}
