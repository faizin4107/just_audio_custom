// // // This example demonstrates how to play a playlist with a mix of URI and asset
// // // audio sources, and the ability to add/remove/reorder playlist items.
// // //
// // // To run:
// // //
// // // flutter run -t lib/example_playlist.dart

// // import 'package:audio_session/audio_session.dart';
// // import 'package:example/common.dart';
// // import 'package:example/example_effects.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:just_audio_custom/just_audio_custom.dart';
// // // import 'package:just_audio_example/common.dart';
// // import 'package:rxdart/rxdart.dart';

// // void main() => runApp(const MyApp());

// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   MyAppState createState() => MyAppState();
// // }

// // class MyAppState extends State<MyApp> with WidgetsBindingObserver {
// //   late AudioPlayer _player;
// //   final _playlist = ConcatenatingAudioSource(children: [
// //     // Remove this audio source from the Windows and Linux version because it's not supported yet
// //     if (kIsWeb ||
// //         ![TargetPlatform.windows, TargetPlatform.linux]
// //             .contains(defaultTargetPlatform))
// //       ClippingAudioSource(
// //         start: const Duration(seconds: 60),
// //         end: const Duration(seconds: 90),
// //         child: AudioSource.uri(Uri.parse(
// //             "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
// //         tag: AudioMetadata(
// //           album: "Science Friday",
// //           title: "A Salute To Head-Scratching Science (30 seconds)",
// //           artwork:
// //               "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
// //         ),
// //       ),
// //     AudioSource.uri(
// //       Uri.parse(
// //           "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
// //       tag: AudioMetadata(
// //         album: "Science Friday",
// //         title: "A Salute To Head-Scratching Science",
// //         artwork:
// //             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
// //       ),
// //     ),
// //     AudioSource.uri(
// //       Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
// //       tag: AudioMetadata(
// //         album: "Science Friday",
// //         title: "From Cat Rheology To Operatic Incompetence",
// //         artwork:
// //             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
// //       ),
// //     ),
// //     AudioSource.uri(
// //       Uri.parse("asset:///audio/nature.mp3"),
// //       tag: AudioMetadata(
// //         album: "Public Domain",
// //         title: "Nature Sounds",
// //         artwork:
// //             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
// //       ),
// //     ),
// //   ]);
// //   int _addedCount = 0;
// //   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
// //   final _equalizer = AndroidEqualizer();
// //   @override
// //   void initState() {
// //     super.initState();
// //     ambiguate(WidgetsBinding.instance)!.addObserver(this);
// //     _player = AudioPlayer(
// //       audioPipeline: AudioPipeline(
// //         androidAudioEffects: [
// //           // _loudnessEnhancer,
// //           _equalizer,
// //         ]
// //       )
// //     );
// //     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
// //       statusBarColor: Colors.black,
// //     ));
// //     _init();
// //   }

// //   Future<void> _init() async {
// //     final session = await AudioSession.instance;
// //     await session.configure(const AudioSessionConfiguration.speech());
// //     // Listen to errors during playback.
// //     _player.playbackEventStream.listen((event) {},
// //         onError: (Object e, StackTrace stackTrace) {
// //       print('A stream error occurred: $e');
// //     });
// //     try {
// //       await _equalizer.setEnabled(true);
// //       // Preloading audio is not currently supported on Linux.
// //       await _player.setAudioSource(_playlist,
// //           preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
// //     } on PlayerException catch (e) {
// //       // Catch load errors: 404, invalid url...
// //       print("Error loading audio source: $e");
// //     }
// //     // Show a snackbar whenever reaching the end of an item in the playlist.
// //     _player.positionDiscontinuityStream.listen((discontinuity) {
// //       if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
// //         _showItemFinished(discontinuity.previousEvent.currentIndex);
// //       }
// //     });
// //     _player.processingStateStream.listen((state) {
// //       if (state == ProcessingState.completed) {
// //         _showItemFinished(_player.currentIndex);
// //       }
// //     });
// //   }

// //   void _showItemFinished(int? index) {
// //     if (index == null) return;
// //     final sequence = _player.sequence;
// //     if (sequence == null) return;
// //     final source = sequence[index];
// //     final metadata = source.tag as AudioMetadata;
// //     _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
// //       content: Text('Finished playing ${metadata.title}'),
// //       duration: const Duration(seconds: 1),
// //     ));
// //   }

// //   @override
// //   void dispose() {
// //     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
// //     _player.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.paused) {
// //       // Release the player's resources when not in use. We use "stop" so that
// //       // if the app resumes later, it will still remember what position to
// //       // resume from.
// //       _player.stop();
// //     }
// //   }

// //   Stream<PositionData> get _positionDataStream =>
// //       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
// //           _player.positionStream,
// //           _player.bufferedPositionStream,
// //           _player.durationStream,
// //           (position, bufferedPosition, duration) => PositionData(
// //               position, bufferedPosition, duration ?? Duration.zero));

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       scaffoldMessengerKey: _scaffoldMessengerKey,
// //       home: Scaffold(
// //         body: SafeArea(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Expanded(
// //                 child: StreamBuilder<SequenceState?>(
// //                   stream: _player.sequenceStateStream,
// //                   builder: (context, snapshot) {
// //                     final state = snapshot.data;
// //                     if (state?.sequence.isEmpty ?? true) {
// //                       return const SizedBox();
// //                     }
// //                     final metadata = state!.currentSource!.tag as AudioMetadata;
// //                     return Column(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Expanded(
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child:
// //                                 Center(child: Image.network(metadata.artwork)),
// //                           ),
// //                         ),
// //                         Text(metadata.album,
// //                             style: Theme.of(context).textTheme.titleLarge),
// //                         Text(metadata.title),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //               ),
// //               ControlButtons(_player),
// //               StreamBuilder<bool>(
// //                 stream: _equalizer.enabledStream,
// //                 builder: (context, snapshot) {
// //                   final enabled = snapshot.data ?? false;
// //                   return SwitchListTile(
// //                             title: Text('Equalizer', 
// //                             style: TextStyle(
// //                               color: Colors.black,
// //                             ),
// //                             // style: GoogleFonts.roboto(
// //                             //                 color: Colors.white,
// //                             //                 fontSize: 12.sp,
// //                             //                 fontWeight: FontWeight.bold
// //                             //               ),
// //                                           ),
// //                             subtitle: GestureDetector(
// //                                   onTap: (){
// //                                     // log.log('enabled: $enabled');
// //                                     // if(!enabled){
// //                                     //    EasyLoading.showInfo(_state.language.value == 'en' ? 'Please enable equalizer' : 'Mohon aktifkan equalizer');
// //                                     // }else{
// //                                     //   showCupertinoModalBottomSheet(
// //                                     //       duration: Duration(
// //                                     //           milliseconds: 400),
// //                                     //       // animationCurve: Curves.easeOut,
// //                                     //       // previousRouteAnimationCurve: Curves.easeOut,
// //                                     //       expand: false,
// //                                     //       context: getX.Get.context!,
// //                                     //       isDismissible: true,
// //                                     //       backgroundColor: Colors.transparent,
// //                                     //       enableDrag: false,
// //                                     //       builder: (context) => SettingEqualizerv9(
// //                                     //         equalizer: _equalizer,
// //                                     //       ));
// //                                     // }
// //                                   },
// //                                   child: Row(
// //                                     children: [
// //                                       Padding(
// //                                         padding: const EdgeInsets.only(top: 8.0),
// //                                         child: Container(
// //                                               height: 20,
// //                                               width: 60,
// //                                               padding: const EdgeInsets.symmetric(vertical: 2),
// //                                               alignment: Alignment.center,
// //                                               decoration: BoxDecoration(
// //                                                 // border: textBtn == 'CANCEL' || textBtn == 'BATAL' ? Border.fromBorderSide(BorderSide(color: info.isColorPrimary.value)) : null,
// //                                                   borderRadius: BorderRadius.all(Radius.circular(5)),
// //                                                   boxShadow: const <BoxShadow>[
// //                                                     BoxShadow(
// //                                                       color: Color.fromRGBO(0, 0, 0, 0.1),
// //                                                       offset: Offset(0, 2),
// //                                                       spreadRadius: 0,
// //                                                       blurRadius: 2,
// //                                                     )
// //                                                   ],
// //                                                   gradient: LinearGradient(
// //                                                       begin: Alignment.centerLeft,
// //                                                       end: Alignment.centerRight,
// //                                                       colors: [Colors.blue, Colors.red]),),
// //                                               child: Row(
// //                                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                                 children: [
// //                                                   Text('Set',
// //                                                       maxLines: 1,
// //                                                       overflow: TextOverflow.ellipsis,
// //                                                       // style: _fontSize.fontRoboto(Colors.black, FontWeight.w700, 12.sp)
// //                                                         ),
// //                                                         SizedBox(width: 3,),
// //                                                   Icon(Icons.equalizer_outlined, color: Colors.black, size: 15,)
// //                                                 ],
// //                                               ),
// //                                                     ),
// //                                       ),
                                      
                                      
// //                                     ],
// //                                   ),
// //                                 ),
// //                             value: enabled,
// //                             onChanged: _equalizer.setEnabled,
// //                           );
// //                 },
// //               ),
// //               Expanded(
// //                                 child: FutureBuilder<AndroidEqualizerParameters>(
// //                                     future: _equalizer.parameters,
// //                                     builder: (context, snapshot) {
// //                                       // widget.equalizer!.parameters.
// //                                       final parameters = snapshot.data;
// //                                       if (parameters == null) return const SizedBox();
                                      
// //                                       // if(_state.genreEqualizer.value == 'Normal'){
// //                                       //   for(var i = 0; i < parameters.bands.length; i++){
// //                                       //     log('index: $i');
// //                                       //     parameters.bands[0].setGainWithIndex(0, 9.13937224820246);
// //                                       //     parameters.bands[4].setGainWithIndex(4, -9.13937224820246);
// //                                       //   }
// //                                       // }
// //                                       // getValueEqualizer(params: parameters);
// //                                       // band.setGainWithIndex(4, 11.13937224820246);
// //                                       // parameters.bands.first.setGainWithIndex(4, -9.13937224820246);
                                      
// //                                       // var gain = parameters.bands.first.gainStream;
// //                                       // for(var band in parameters.bands){
// //                                       //   // log('centerFrequency: ${band.centerFrequency}');
// //                                       //   // log('gain: ${band.gain}');
// //                                       //   // log('lowerFrequency: ${band.lowerFrequency}');
// //                                       //   // log('upperFrequency: ${band.upperFrequency}');
// //                                       //   // log('gainStream: ${band.gainStream}');
// //                                       //   // log('index: ${band.index}');
// //                                       //   band.setGainWithIndex(indexEq, gain)
// //                                       // }
// //                                       double newGain = 0.0;
                                      
// //                                       return Row(
// //                                         mainAxisSize: MainAxisSize.max,
// //                                         children: [
// //                                           for (var band in parameters.bands)
// //                                             Expanded(
// //                                               child: Column(
// //                                                 children: [
// //                                                   Expanded(
// //                                                     child: StreamBuilder<double>(
// //                                                       stream: band.gainStream,
// //                                                       builder: (context, snapshot) {
                                                        
// //                                                         // if(newSetGain == false){
                                                          
// //                                                         // }else{
// //                                                         //   newGain = band.gain;
// //                                                         // }
// //                                                         // if(_state.isSetGain.value == true){
// //                                                         //   newGain = band.gain;
// //                                                         // }else{
                                                          
// //                                                         // }
// //                                                         // if(band.gain > 1.5){
// //                                                         //     newGain = band.gain / 10;
// //                                                         //     // band.setGain(band.gain / 10);
// //                                                         //   }else{
// //                                                         //     newGain = band.gain;
// //                                                         //   }
// //                                                         // log('index ${band.index}');
// //                                                         // log('snapshowt ${band.gain}');
// //                                                         // log('newSetGain $newSetGain');
                                                        
// //                                                         // log('newSetGain 2 $newSetGain');
                                                        
// //                                                       // band.setGain(11.13937224820246);
// //                                                       // band.setGainWithIndex(5, 11.13937224820246);
// //                                                         return VerticalSlider(
// //                                                           min: parameters.minDecibels,
// //                                                           max: parameters.maxDecibels,
// //                                                           value: newGain,
// //                                                           onChanged: band.setGain,
// //                                                         );
// //                                                         // return Container();
// //                                                       },
// //                                                     ),
// //                                                   ),
// //                                                   Text('${band.centerFrequency.round()} Hz',
// //                                                 //     style: GoogleFonts.roboto(
// //                                                 //   color: Colors.white,
// //                                                 //   fontSize: 10.sp,
// //                                                 //   fontWeight: FontWeight.bold
// //                                                 // ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                         ],
// //                                       );
// //                                     },
// //                                   ),
// //                               ),
// //               StreamBuilder<PositionData>(
// //                 stream: _positionDataStream,
// //                 builder: (context, snapshot) {
// //                   final positionData = snapshot.data;
// //                   return SeekBar(
// //                     duration: positionData?.duration ?? Duration.zero,
// //                     position: positionData?.position ?? Duration.zero,
// //                     bufferedPosition:
// //                         positionData?.bufferedPosition ?? Duration.zero,
// //                     onChangeEnd: (newPosition) {
// //                       _player.seek(newPosition);
// //                     },
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: 8.0),

// //               Row(
// //                 children: [
// //                   StreamBuilder<LoopMode>(
// //                     stream: _player.loopModeStream,
// //                     builder: (context, snapshot) {
// //                       final loopMode = snapshot.data ?? LoopMode.off;
// //                       const icons = [
// //                         Icon(Icons.repeat, color: Colors.grey),
// //                         Icon(Icons.repeat, color: Colors.orange),
// //                         Icon(Icons.repeat_one, color: Colors.orange),
// //                       ];
// //                       const cycleModes = [
// //                         LoopMode.off,
// //                         LoopMode.all,
// //                         LoopMode.one,
// //                       ];
// //                       final index = cycleModes.indexOf(loopMode);
// //                       return IconButton(
// //                         icon: icons[index],
// //                         onPressed: () {
// //                           _player.setLoopMode(cycleModes[
// //                               (cycleModes.indexOf(loopMode) + 1) %
// //                                   cycleModes.length]);
// //                         },
// //                       );
// //                     },
// //                   ),
// //                   Expanded(
// //                     child: Text(
// //                       "Playlist",
// //                       style: Theme.of(context).textTheme.titleLarge,
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                   StreamBuilder<bool>(
// //                     stream: _player.shuffleModeEnabledStream,
// //                     builder: (context, snapshot) {
// //                       final shuffleModeEnabled = snapshot.data ?? false;
// //                       return IconButton(
// //                         icon: shuffleModeEnabled
// //                             ? const Icon(Icons.shuffle, color: Colors.orange)
// //                             : const Icon(Icons.shuffle, color: Colors.grey),
// //                         onPressed: () async {
// //                           final enable = !shuffleModeEnabled;
// //                           if (enable) {
// //                             await _player.shuffle();
// //                           }
// //                           await _player.setShuffleModeEnabled(enable);
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(
// //                 height: 240.0,
// //                 child: StreamBuilder<SequenceState?>(
// //                   stream: _player.sequenceStateStream,
// //                   builder: (context, snapshot) {
// //                     final state = snapshot.data;
// //                     final sequence = state?.sequence ?? [];
// //                     return ReorderableListView(
// //                       onReorder: (int oldIndex, int newIndex) {
// //                         if (oldIndex < newIndex) newIndex--;
// //                         _playlist.move(oldIndex, newIndex);
// //                       },
// //                       children: [
// //                         for (var i = 0; i < sequence.length; i++)
// //                           Dismissible(
// //                             key: ValueKey(sequence[i]),
// //                             background: Container(
// //                               color: Colors.redAccent,
// //                               alignment: Alignment.centerRight,
// //                               child: const Padding(
// //                                 padding: EdgeInsets.only(right: 8.0),
// //                                 child: Icon(Icons.delete, color: Colors.white),
// //                               ),
// //                             ),
// //                             onDismissed: (dismissDirection) {
// //                               _playlist.removeAt(i);
// //                             },
// //                             child: Material(
// //                               color: i == state!.currentIndex
// //                                   ? Colors.grey.shade300
// //                                   : null,
// //                               child: ListTile(
// //                                 title: Text(sequence[i].tag.title as String),
// //                                 onTap: () {
// //                                   _player.seek(Duration.zero, index: i);
// //                                 },
// //                               ),
// //                             ),
// //                           ),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         floatingActionButton: FloatingActionButton(
// //           child: const Icon(Icons.add),
// //           onPressed: () {
// //             _playlist.add(AudioSource.uri(
// //               Uri.parse("asset:///audio/nature.mp3"),
// //               tag: AudioMetadata(
// //                 album: "Public Domain",
// //                 title: "Nature Sounds ${++_addedCount}",
// //                 artwork:
// //                     "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
// //               ),
// //             ));
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ControlButtons extends StatelessWidget {
// //   final AudioPlayer player;

// //   const ControlButtons(this.player, {Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         IconButton(
// //           icon: const Icon(Icons.volume_up),
// //           onPressed: () {
// //             showSliderDialog(
// //               context: context,
// //               title: "Adjust volume",
// //               divisions: 10,
// //               min: 0.0,
// //               max: 1.0,
// //               value: player.volume,
// //               stream: player.volumeStream,
// //               onChanged: player.setVolume,
// //             );
// //           },
// //         ),
// //         StreamBuilder<SequenceState?>(
// //           stream: player.sequenceStateStream,
// //           builder: (context, snapshot) => IconButton(
// //             icon: const Icon(Icons.skip_previous),
// //             onPressed: player.hasPrevious ? player.seekToPrevious : null,
// //           ),
// //         ),
// //         StreamBuilder<PlayerState>(
// //           stream: player.playerStateStream,
// //           builder: (context, snapshot) {
// //             final playerState = snapshot.data;
// //             final processingState = playerState?.processingState;
// //             final playing = playerState?.playing;
// //             if (processingState == ProcessingState.loading ||
// //                 processingState == ProcessingState.buffering) {
// //               return Container(
// //                 margin: const EdgeInsets.all(8.0),
// //                 width: 64.0,
// //                 height: 64.0,
// //                 child: const CircularProgressIndicator(),
// //               );
// //             } else if (playing != true) {
// //               return IconButton(
// //                 icon: const Icon(Icons.play_arrow),
// //                 iconSize: 64.0,
// //                 onPressed: player.play,
// //               );
// //             } else if (processingState != ProcessingState.completed) {
// //               return IconButton(
// //                 icon: const Icon(Icons.pause),
// //                 iconSize: 64.0,
// //                 onPressed: player.pause,
// //               );
// //             } else {
// //               return IconButton(
// //                 icon: const Icon(Icons.replay),
// //                 iconSize: 64.0,
// //                 onPressed: () => player.seek(Duration.zero,
// //                     index: player.effectiveIndices!.first),
// //               );
// //             }
// //           },
// //         ),
// //         StreamBuilder<SequenceState?>(
// //           stream: player.sequenceStateStream,
// //           builder: (context, snapshot) => IconButton(
// //             icon: const Icon(Icons.skip_next),
// //             onPressed: player.hasNext ? player.seekToNext : null,
// //           ),
// //         ),
// //         StreamBuilder<double>(
// //           stream: player.speedStream,
// //           builder: (context, snapshot) => IconButton(
// //             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
// //                 style: const TextStyle(fontWeight: FontWeight.bold)),
// //             onPressed: () {
// //               showSliderDialog(
// //                 context: context,
// //                 title: "Adjust speed",
// //                 divisions: 10,
// //                 min: 0.5,
// //                 max: 1.5,
// //                 value: player.speed,
// //                 stream: player.speedStream,
// //                 onChanged: player.setSpeed,
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class AudioMetadata {
// //   final String album;
// //   final String title;
// //   final String artwork;

// //   AudioMetadata({
// //     required this.album,
// //     required this.title,
// //     required this.artwork,
// //   });
// // }

// // This example demonstrates how to play a playlist with a mix of URI and asset
// // audio sources, and the ability to add/remove/reorder playlist items.
// //
// // To run:
// //
// // flutter run -t lib/example_playlist.dart

// import 'dart:async';

// import 'package:example/common.dart';
// import 'package:just_audio_custom/just_audio_custom.dart';

// // import 'media_kit_stub.dart' if (dart.library.io) 'media_kit_impl.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:just_audio_example/common.dart';
// import 'package:rxdart/rxdart.dart';

// void main() {
//   // initMediaKit(); // Initialise just_audio_media_kit for Linux/Windows.
//   // Enable gapless playback on Linux/Windows (experimental):
//   // JustAudioMediaKit.prefetchPlaylist = true;
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   late AudioPlayer _player;
//   static final _playlist = [
//     ClippingAudioSource(
//       start: const Duration(seconds: 60),
//       end: const Duration(seconds: 90),
//       child: AudioSource.uri(Uri.parse(
//           "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
//       tag: AudioMetadata(
//         album: "Science Friday",
//         title: "A Salute To Head-Scratching Science (30 seconds)",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//     AudioSource.uri(
//       Uri.parse(
//           "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
//       tag: AudioMetadata(
//         album: "Science Friday",
//         title: "A Salute To Head-Scratching Science",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//     AudioSource.uri(
//       Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
//       tag: AudioMetadata(
//         album: "Science Friday",
//         title: "From Cat Rheology To Operatic Incompetence",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//     AudioSource.uri(
//       Uri.parse("asset:///audio/nature.mp3"),
//       tag: AudioMetadata(
//         album: "Public Domain",
//         title: "Nature Sounds",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//   ];
//   int _addedCount = 0;
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//   @override
//   void initState() {
//     super.initState();
//     ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     _player = AudioPlayer(maxSkipsOnError: 3);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     _init();
//   }

//   Future<void> _init() async {
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.speech());
//     // Listen to errors during playback.
//     _player.errorStream.listen((e) {
//       print('A stream error occurred: $e');
//     });
//     try {
//       await _player.setAudioSources(_playlist);
//     } on PlayerException catch (e) {
//       // Catch load errors: 404, invalid url...
//       print("Error loading playlist: $e");
//     }
//     // Show a snackbar whenever reaching the end of an item in the playlist.
//     _player.positionDiscontinuityStream.listen((discontinuity) {
//       if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
//         _showItemFinished(discontinuity.previousEvent.currentIndex);
//       }
//     });
//     _player.processingStateStream.listen((state) {
//       if (state == ProcessingState.completed) {
//         _showItemFinished(_player.currentIndex);
//       }
//     });
//   }

//   void _showItemFinished(int? index) {
//     if (index == null) return;
//     final sequence = _player.sequence;
//     if (index >= sequence.length) return;
//     final source = sequence[index];
//     final metadata = source.tag as AudioMetadata;
//     _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
//       content: Text('Finished playing ${metadata.title}'),
//       duration: const Duration(seconds: 1),
//     ));
//   }

//   @override
//   void dispose() {
//     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // Release the player's resources when not in use. We use "stop" so that
//       // if the app resumes later, it will still remember what position to
//       // resume from.
//       _player.stop();
//     }
//   }

//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//           _player.positionStream,
//           _player.bufferedPositionStream,
//           _player.durationStream,
//           (position, bufferedPosition, duration) => PositionData(
//               position, bufferedPosition, duration ?? Duration.zero));

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       scaffoldMessengerKey: _scaffoldMessengerKey,
//       home: Scaffold(
//         body: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: StreamBuilder<SequenceState?>(
//                   stream: _player.sequenceStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     if (state?.sequence.isEmpty ?? true) {
//                       return const SizedBox();
//                     }
//                     final metadata = state!.currentSource!.tag as AudioMetadata;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child:
//                                 Center(child: Image.network(metadata.artwork)),
//                           ),
//                         ),
//                         Text(metadata.album,
//                             style: Theme.of(context).textTheme.titleLarge),
//                         Text(metadata.title),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               ControlButtons(_player),
//               StreamBuilder<PositionData>(
//                 stream: _positionDataStream,
//                 builder: (context, snapshot) {
//                   final positionData = snapshot.data;
//                   return SeekBar(
//                     duration: positionData?.duration ?? Duration.zero,
//                     position: positionData?.position ?? Duration.zero,
//                     bufferedPosition:
//                         positionData?.bufferedPosition ?? Duration.zero,
//                     onChangeEnd: (newPosition) {
//                       _player.seek(newPosition);
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 children: [
//                   StreamBuilder<LoopMode>(
//                     stream: _player.loopModeStream,
//                     builder: (context, snapshot) {
//                       final loopMode = snapshot.data ?? LoopMode.off;
//                       const icons = [
//                         Icon(Icons.repeat, color: Colors.grey),
//                         Icon(Icons.repeat, color: Colors.orange),
//                         Icon(Icons.repeat_one, color: Colors.orange),
//                       ];
//                       const cycleModes = [
//                         LoopMode.off,
//                         LoopMode.all,
//                         LoopMode.one,
//                       ];
//                       final index = cycleModes.indexOf(loopMode);
//                       return IconButton(
//                         icon: icons[index],
//                         onPressed: () {
//                           _player.setLoopMode(cycleModes[
//                               (cycleModes.indexOf(loopMode) + 1) %
//                                   cycleModes.length]);
//                         },
//                       );
//                     },
//                   ),
//                   Expanded(
//                     child: Text(
//                       "Playlist",
//                       style: Theme.of(context).textTheme.titleLarge,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   StreamBuilder<bool>(
//                     stream: _player.shuffleModeEnabledStream,
//                     builder: (context, snapshot) {
//                       final shuffleModeEnabled = snapshot.data ?? false;
//                       return IconButton(
//                         icon: shuffleModeEnabled
//                             ? const Icon(Icons.shuffle, color: Colors.orange)
//                             : const Icon(Icons.shuffle, color: Colors.grey),
//                         onPressed: () async {
//                           final enable = !shuffleModeEnabled;
//                           if (enable) {
//                             await _player.shuffle();
//                           }
//                           await _player.setShuffleModeEnabled(enable);
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 240.0,
//                 child: StreamBuilder<SequenceState?>(
//                   stream: _player.sequenceStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     final sequence = state?.sequence ?? [];
//                     return ReorderableListView(
//                       onReorder: (int oldIndex, int newIndex) {
//                         if (oldIndex < newIndex) newIndex--;
//                         _player.moveAudioSource(oldIndex, newIndex);
//                       },
//                       children: [
//                         for (var i = 0; i < sequence.length; i++)
//                           Dismissible(
//                             key: ValueKey(sequence[i]),
//                             background: Container(
//                               color: Colors.redAccent,
//                               alignment: Alignment.centerRight,
//                               child: const Padding(
//                                 padding: EdgeInsets.only(right: 8.0),
//                                 child: Icon(Icons.delete, color: Colors.white),
//                               ),
//                             ),
//                             onDismissed: (dismissDirection) =>
//                                 _player.removeAudioSourceAt(i),
//                             child: Material(
//                               color: i == state!.currentIndex
//                                   ? Colors.grey.shade300
//                                   : null,
//                               child: ListTile(
//                                 title: Text(sequence[i].tag.title as String),
//                                 onTap: () => _player
//                                     .seek(Duration.zero, index: i)
//                                     .catchError((e, st) {}),
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () {
//             _player.addAudioSource(AudioSource.uri(
//               Uri.parse("asset:///audio/nature.mp3"),
//               tag: AudioMetadata(
//                 album: "Public Domain",
//                 title: "Nature Sounds ${++_addedCount}",
//                 artwork:
//                     "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//               ),
//             ));
//           },
//         ),
//       ),
//     );
//   }
// }

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;

//   const ControlButtons(this.player, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               value: player.volume,
//               stream: player.volumeStream,
//               onChanged: player.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: const Icon(Icons.skip_previous),
//             onPressed: player.hasPrevious ? player.seekToPrevious : null,
//           ),
//         ),
//         StreamBuilder<(bool, ProcessingState, int)>(
//           stream: Rx.combineLatest2(
//               player.playerEventStream,
//               player.sequenceStream,
//               (event, sequence) => (
//                     event.playing,
//                     event.playbackEvent.processingState,
//                     sequence.length,
//                   )),
//           builder: (context, snapshot) {
//             final (playing, processingState, sequenceLength) =
//                 snapshot.data ?? (false, null, 0);
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (!playing) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: sequenceLength > 0 ? player.play : null,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: sequenceLength > 0
//                     ? () => player.seek(Duration.zero,
//                         index: player.effectiveIndices.first)
//                     : null,
//               );
//             }
//           },
//         ),
//         StreamBuilder<SequenceState?>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: const Icon(Icons.skip_next),
//             onPressed: player.hasNext ? player.seekToNext : null,
//           ),
//         ),
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 value: player.speed,
//                 stream: player.speedStream,
//                 onChanged: player.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AudioMetadata {
//   final String album;
//   final String title;
//   final String artwork;

//   AudioMetadata({
//     required this.album,
//     required this.title,
//     required this.artwork,
//   });
// }
