import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({super.key, required String using}) : _path = using;

  final String _path;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    await _player.setUrl(widget._path);
  }

  void _onAudioButtonPressed() async {
    if (_player.playing == true) {
      // _player.pause();
      _player.seek(Duration(seconds: 0));
    }
    await _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        onPressed: () => _onAudioButtonPressed(), icon: Icon(Icons.speaker));
  }
}
