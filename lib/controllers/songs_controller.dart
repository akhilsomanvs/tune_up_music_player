import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songsList = [];

  List<SongModel> get songsList => _songsList;

  Future<bool> requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        return await _audioQuery.permissionsRequest();
      }
    }
    return false;
  }

  Future<bool> getStoragePermissionStatus() async {
    if (!kIsWeb) {
      return await _audioQuery.permissionsStatus();
    }
    return false;
  }

  getSongsFromDevice() async {
    List<SongModel> list = [];
    if (await requestPermission()) {
      list = await _audioQuery.querySongs(
        sortType: SongSortType.DISPLAY_NAME,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    }
    debugPrint("SONGS LIST :::: ${list.length}");
    _songsList = list;
  }
}
