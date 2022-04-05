import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaySound {
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;
  play({required String path, required String fileName}) async {
    final prefs = await SharedPreferences.getInstance();
    bool permissionAudio = prefs.getBool("permissionAudio") ?? true;
    if (permissionAudio) {
      advancedPlayer = AudioPlayer();
      audioCache = AudioCache(fixedPlayer: advancedPlayer, prefix: path);
      await audioCache.play(fileName);
    }
  }

  stop() async {
    advancedPlayer.stop();
  }
}
