import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaySound {
  play({required String path, required String fileName}) async {
    final prefs = await SharedPreferences.getInstance();
    bool permissionAudio = prefs.getBool("permissionAudio") ?? true;
    if (permissionAudio) {
      AudioPlayer advancedPlayer;
      AudioCache audioCache;
      advancedPlayer = AudioPlayer();
      audioCache = AudioCache(fixedPlayer: advancedPlayer, prefix: path);
      await audioCache.play(fileName);
    }
  }
}
