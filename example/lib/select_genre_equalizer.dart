// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// // import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:just_audio/just_audio.dart';
// import 'package:kit_project/controller/appstate.dart';
// // import 'package:kit_project/controller/chat_ai.dart';
// import 'package:kit_project/controller/fontsize.dart';
// // import 'package:kit_project/view/ftube-music/play_music.dart';
// import 'package:kit_project/widget/button/button_row.dart';
// import 'package:kit_project/widget/loading/loading_app.dart';
// import 'package:kit_project/widget/scroll/default_scroll.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SelectGenreEqualizer extends StatefulWidget {
//   const SelectGenreEqualizer({super.key, this.genreUser});
//   final String? genreUser;
//   @override
//   State<SelectGenreEqualizer> createState() => _SelectGenreEqualizerState();
// }

// class _SelectGenreEqualizerState extends State<SelectGenreEqualizer> {
//   final AppStateController _state = Get.find();
//   final FontSizeController _fontSize = Get.find();
//   // final ChatAiController _chatAi = Get.find();
//   // List<dynamic> listQustion = [];
//   String? _selectGenre = '';
//   final List<String> _list = [
//     'Normal', 'Classical', 'Dance', 'Flat', 'Folk', 'Heavy Metal', 'Hip Hop', 'Jazz', 'Pop', 'Rock', 'FX Booster'
//   ];
//   // String? _nameCompany;

//   bool _loading = false;

//   @override
//   void initState() {
//     setState(() {
//       _loading = true;
//     });
    
//     getSettingEqualizer();
//     setState(() {
//       _selectGenre = widget.genreUser;
//      _loading = false;
//     });
//     // setState(() {
//     //   _list.add('normal');
//     // });
//     // getList();
//     super.initState();
//   }

//   getSettingEqualizer() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? userSetting = prefs.getStringList('user_settings_equalizer');
//     if(userSetting == null){

//     }
//   }

//   // getList() async {
//   //   setState(() {
//   //     _loading = true;
//   //   });
//   //   // listQustion.add(_state.language.value == 'en' ? 'How much leave do I have left?' : 'Berapa sisa cuti ku');
//   //   // listQustion.add(_state.language.value == 'en' ? 'How to apply for leave' : 'Cara mengajukan cuti');
//   //   // listQustion.add(_state.language.value == 'en' ? 'How to check notifications' : 'Cara cek notifikasi');
//   //   setState(() {
//   //     _loading = false;
//   //   });
//   // }

  
//   @override
//   Widget build(BuildContext context) {
//     // final AccountController account = Get.put(AccountController());
//     const curve = Curves.ease;
//      var durationMS = 600;
//     return Obx(() => PopScope(
//           canPop: true,
//         onPopInvokedWithResult: (didPop, result) {
//            EasyLoading.dismiss();
//             // Get.back();
//         },
//           child: AnimatedContainer(
//             curve: curve,
//             duration: Duration(milliseconds: durationMS),
//             child: SafeArea(
//               child: Material(
//                 color: const Color(0xFFF9F9F9),
//                   child: SizedBox(
//                 height: 0.58.sh,
//                 child: Stack(
//                   children: [
//                     Scaffold(
//                       backgroundColor: _state.isTheme.value == 'dark' ? Colors.black : Colors.white,
//                         resizeToAvoidBottomInset: true,
//                         bottomNavigationBar: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 20.0, bottom: 0.0),
//                           child: Row(
//                             children: [
                            
//                               Expanded(
//                                   child: Obx(
//                                 () => InkWell(
//                                   onTap: () async {
//                                     Get.back(result: '');
//                                   },
//                                   child: ButtonRow(
//                                     textBtn: _state.language.value == 'en'
//                                       ? 'CLOSE'
//                                       : 'TUTUP',
//                                     orangeColor1: _state.isTheme.value == 'dark' ? Colors.green : const Color(0xFF232B5F),
//                                     orangeColor2: _state.isTheme.value == 'dark' ? Colors.white70 : const Color(0xFF232B5F),
//                                     widthBtn: 40.w,
//                                     heightBtn: 28.52.h,
//                                     fontSize: 14,
//                                     colorText: Colors.white,
//                                     fontWeight: FontWeight.w700, 
//                                   ),
//                                 ),
//                               )),
//                             ],
//                           ),
//                         ),
//                         body: Padding(
//                           padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 20, bottom: 20),
//                           child: Column(
//                             children: [
//                               Expanded(
//                                 child: ScrollConfiguration(
//                                   behavior: DefaultScroll(),
//                                   child: 
//                                   _loading
//                                     ? Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         LoadingApp(
//                                             topPaddingLoading: 50),
//                                       ],
//                                     )
//                                     : ListView.builder(
//                                         reverse: false,
//                                         shrinkWrap: true,
//                                         physics:
//                                             const AlwaysScrollableScrollPhysics(),
//                                         itemCount: _list.length,
//                                         itemBuilder:
//                                             (BuildContext context,
//                                                 int index) {
//                                           // var post = widget.typeQuestion == 'ats' ? _chatAi.listQuestionAts[index] : _chatAi.listQuestion[index];
    
//                                           return RadioListTile(
//                                               activeColor: _state.isTheme.value == 'dark' ? Colors.white : _state.isColorPrimary.value,
//                                               title: Text(
//                                                 _list[index].toString(),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow
//                                                     .ellipsis,
//                                                 style: _fontSize.fontRoboto(_state.isTheme.value == 'dark' ? Colors.white : Colors.black, FontWeight.normal, 12.sp),
                                                
//                                               ),
//                                               value: _list[index].toString(),
//                                               groupValue: _selectGenre,
//                                               onChanged: (val) async {
//                                                 log('value: $val');
//                                                 // setState(() {
//                                                 //   _selectGenre = val;
//                                                 //   // _selectQuestion =
//                                                 //   //     val.toString();
//                                                 // });
//                                                 // final prefs = await SharedPreferences.getInstance();
//                                                 // prefs.setString('genre', val.toString());
//                                                 Get.back(result: _selectGenre);
//                                               });
//                                         },
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         )),
//                   ],
//                 ),
//               )),
//             ),
//           ),
//         ));
//   }
// }
