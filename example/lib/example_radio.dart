// // // This is a minimal example demonstrating live streaming.
// // //
// // // To run:
// // //
// // // flutter run -t lib/example_radio.dart

// // import 'package:audio_session/audio_session.dart';
// // import 'package:example/common.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:just_audio_custom/just_audio_custom.dart';
// // // import 'package:just_audio_example/common.dart';

// // void main() => runApp(const MyApp());

// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   MyAppState createState() => MyAppState();
// // }

// // class MyAppState extends State<MyApp> with WidgetsBindingObserver {
// //   final _player = AudioPlayer();

// //   @override
// //   void initState() {
// //     super.initState();
// //     ambiguate(WidgetsBinding.instance)!.addObserver(this);
// //     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
// //       statusBarColor: Colors.black,
// //     ));
// //     _init();
// //   }

// //   Future<void> _init() async {
// //     // Inform the operating system of our app's audio attributes etc.
// //     // We pick a reasonable default for an app that plays speech.
// //     final session = await AudioSession.instance;
// //     await session.configure(const AudioSessionConfiguration.speech());
// //     // Listen to errors during playback.
// //     _player.playbackEventStream.listen((event) {},
// //         onError: (Object e, StackTrace stackTrace) {
// //       print('A stream error occurred: $e');
// //     });
// //     // Try to load audio from a source and catch any errors.
// //     try {
// //       await _player.setAudioSource(AudioSource.uri(
// //           Uri.parse("https://stream-uk1.radioparadise.com/aac-320")));
// //     } on PlayerException catch (e) {
// //       print("Error loading audio source: $e");
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
// //     // Release decoders and buffers back to the operating system making them
// //     // available for other apps to use.
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

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: Scaffold(
// //         body: SafeArea(
// //           child: SizedBox(
// //             width: double.maxFinite,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 StreamBuilder<IcyMetadata?>(
// //                   stream: _player.icyMetadataStream,
// //                   builder: (context, snapshot) {
// //                     final metadata = snapshot.data;
// //                     final title = metadata?.info?.title ?? '';
// //                     final url = metadata?.info?.url;
// //                     return Column(
// //                       children: [
// //                         if (url != null) Image.network(url),
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 8.0),
// //                           child: Text(title,
// //                               style: Theme.of(context).textTheme.titleLarge),
// //                         ),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //                 // Display play/pause button and volume/speed sliders.
// //                 ControlButtons(_player),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // /// Displays the play/pause button and volume/speed sliders.
// // class ControlButtons extends StatelessWidget {
// //   final AudioPlayer player;

// //   const ControlButtons(this.player, {Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         /// This StreamBuilder rebuilds whenever the player state changes, which
// //         /// includes the playing/paused state and also the
// //         /// loading/buffering/ready state. Depending on the state we show the
// //         /// appropriate button or loading indicator.
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
// //                 onPressed: () => player.seek(Duration.zero),
// //               );
// //             }
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }

// // This is a minimal example demonstrating live streaming.
// //
// // To run:
// //
// // flutter run -t lib/example_radio.dart

// import 'package:example/common.dart';
// import 'package:just_audio_custom/just_audio_custom.dart';

// // import 'media_kit_stub.dart' if (dart.library.io) 'media_kit_impl.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:just_audio_example/common.dart';

// void main() {
//   // initMediaKit(); // Initialise just_audio_media_kit for Linux/Windows.
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final _player = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     _init();
//   }

//   Future<void> _init() async {
//     // Inform the operating system of our app's audio attributes etc.
//     // We pick a reasonable default for an app that plays speech.
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.speech());
//     // Listen to errors during playback.
//     _player.errorStream.listen((e) {
//       print('A stream error occurred: $e');
//     });
//     // Try to load audio from a source and catch any errors.
//     try {
//       await _player.setAudioSource(AudioSource.uri(
//           Uri.parse("https://stream-uk1.radioparadise.com/aac-320")));
//     } on PlayerException catch (e) {
//       print("Error loading audio source: $e");
//     }
//   }

//   @override
//   void dispose() {
//     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
//     // Release decoders and buffers back to the operating system making them
//     // available for other apps to use.
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

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 StreamBuilder<IcyMetadata?>(
//                   stream: _player.icyMetadataStream,
//                   builder: (context, snapshot) {
//                     final metadata = snapshot.data;
//                     final title = metadata?.info?.title ?? '';
//                     final url = metadata?.info?.url;
//                     return Column(
//                       children: [
//                         if (url != null) Image.network(url),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(title,
//                               style: Theme.of(context).textTheme.titleLarge),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 // Display play/pause button and volume/speed sliders.
//                 ControlButtons(_player),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Displays the play/pause button and volume/speed sliders.
// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;

//   const ControlButtons(this.player, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         /// This StreamBuilder rebuilds whenever the player state changes, which
//         /// includes the playing/paused state and also the
//         /// loading/buffering/ready state. Depending on the state we show the
//         /// appropriate button or loading indicator.
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
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
//                 onPressed: () => player.seek(Duration.zero),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
