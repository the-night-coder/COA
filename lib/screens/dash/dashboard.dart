import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:coa/api/api_repo.dart';
import 'package:coa/bloc/dashboard/dashboard_bloc.dart';
import 'package:coa/bloc/slider/slider_bloc.dart';
import 'package:coa/screens/broadband_view/broadband_view.dart';
import 'package:coa/screens/broadbands/broadbands.dart';
import 'package:coa/screens/devices/devices.dart';
import 'package:coa/screens/drawer/app_drawer.dart';
import 'package:coa/screens/help/help_support.dart';
import 'package:coa/screens/id_card/id_card.dart';
import 'package:coa/screens/settings/settings.dart';
import 'package:coa/support/app_colors.dart';
import 'package:coa/support/app_icons.dart';
import 'package:coa/support/app_text.dart';
import 'package:coa/support/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../support/prefs.dart';
import '../profile/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ImagePicker picker = ImagePicker();
  final _bloc = DashboardBloc();
  dynamic _user;
  dynamic _dash;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.primary));
    _bloc.add(DashboardBlocLoadEvent());
    _getUser();
    _getDash();
    super.initState();
  }

  Future<void> _getUser() async {
    _user = jsonDecode(await Pref.getUser() ?? '');
    setState(() {});
    print(_user);
  }

  Future<void> _getDash() async {
    _dash = jsonDecode(await Pref.getDash() ?? '');
    setState(() {});
    print(_dash);
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              surfaceTintColor: AppColors.white,
              backgroundColor: AppColors.white,
              title: AppText.boldText('Profile photo missing!',
                  size: 18, color: AppColors.warning),
              content: AppText.mediumText(
                  "You haven't uploaded the profile photo, please upload one!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: AppText.boldText('Close')),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            color: AppColors.greyText, width: 0.5)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showUploadDialog();
                    },
                    child: AppText.boldText('Upload now',
                        color: AppColors.primary)),
              ],
            ));
  }

  _showUploadDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              surfaceTintColor: AppColors.white,
              backgroundColor: AppColors.white,
              title: AppText.boldText('Choose option',
                  size: 18, color: AppColors.text),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: AppText.mediumText('Open camera'),
                    leading: const Icon(Icons.camera_alt_outlined),
                    onTap: () {
                      Navigator.of(context).pop();
                      _takeImage();
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.image_outlined),
                    title: AppText.mediumText('Open gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage();
                    },
                  )
                ],
              ),
            ));
  }

  _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      if (croppedFile != null) {
        _uploadImage(File(croppedFile.path));
      } else {
        context.errorDialog('Error', 'Please take a photo');
      }
    } else {
      context.errorDialog('Error', 'Please choose an image');
    }
  }

  _uploadImage(File photo) async {
    EasyLoading.show(
        status: 'Uploading',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    final resp = await ApiRepository()
        .updateProfilePhoto(_user['username'] ?? '', photo);
    if (resp.status) {
      context.successDialog('Profile photo uploaded',
          'Your profile photo has been uploaded', () => {});
      _bloc.add(DashboardBlocLoadEvent());
    } else {
      context.successDialog('Profile photo upload failed',
          resp.message ?? "Something went wrong", () => {});
    }
    EasyLoading.dismiss();
  }

  _takeImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      if (croppedFile != null) {
        _uploadImage(File(croppedFile.path));
      } else {
        context.errorDialog('Error', 'Please take a photo');
      }
    } else {
      context.errorDialog('Error', 'Please take a photo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        drawer: const AppDrawer(),
        body: _body(),
        bottomNavigationBar: Container(
          height: 70,
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Icon(Icons.home_outlined, color: AppColors.white),
                        AppText.mediumText('Home', color: AppColors.white),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileView()));
                    },
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            color: AppColors.white),
                        AppText.mediumText('My Profile',
                            color: AppColors.white),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Settings()));
                    },
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const Icon(Icons.settings_outlined,
                            color: AppColors.white),
                        AppText.mediumText('Settings', color: AppColors.white),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HelpSupport()));
                    },
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const Icon(Icons.support_agent_rounded,
                            color: AppColors.white),
                        AppText.mediumText('Help', color: AppColors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  _appBar() => AppBar(
        title: Image.asset(
          AppIcons.logo,
          height: 40,
        ),
        backgroundColor: AppColors.white,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          clipBehavior: Clip.hardEdge,
                          contentPadding: EdgeInsets.zero,
                          surfaceTintColor: AppColors.white,
                          backgroundColor: AppColors.white,
                          content: IdCard(),
                        ));
              },
              icon: const Icon(Icons.qr_code)),
          const SizedBox(width: 10),
        ],
      );

  _body() => BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is DashboardBlocSuccess) {
          if ((state.data?['data']?['user']?['media'] as List<dynamic>)
              .isEmpty) {
            _showDialog();
          }
          _getUser();
          _getDash();
        }
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                SafeArea(
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.card,
                          gradient: LinearGradient(
                              colors: [AppColors.white, AppColors.primary],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(26),
                              bottomRight: Radius.circular(26))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfileView()));
                        },
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: [
                            Container(
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2,
                                      color: _user['is_approved'] == 'approved'
                                          ? AppColors.success
                                          : AppColors.danger)),
                              child: ClipOval(
                                child: Builder(builder: (context) {
                                  if (((_user?['media'] ?? []) as List<dynamic>)
                                      .isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.person_rounded),
                                    );
                                  } else {
                                    return Image.network(
                                      _user!['media'][0]['original_url']
                                          .toString()
                                          .replaceAll('https', 'http'),
                                      width: 50,
                                      height: 50,
                                    );
                                  }
                                }),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.boldText('Welcome'),
                                AppText.boldText(
                                    (_user['name'] ?? 'Loading')
                                        .toString()
                                        .toUpperCase(),
                                    color: AppColors.white),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                        clipBehavior: Clip.hardEdge,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryLight),
                        child: _slider(_dash?['welcome_messages'] ?? [])),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Devices()));
                            },
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                  width: 1.5, color: AppColors.hint),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  AppIcons.cableTv,
                                  width: 60,
                                ),
                                const SizedBox(height: 10),
                                AppText.mediumText('Digital IDs',
                                    color: AppColors.primary)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Broadband()));
                            },
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                  width: 1.5, color: AppColors.hint),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  AppIcons.wifiSignal,
                                  width: 60,
                                ),
                                const SizedBox(height: 10),
                                AppText.mediumText('Broadband IDs',
                                    color: AppColors.primary)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    AppText.boldText('Shares'),
                    const SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        _listIte('CIDCO'),
                        const SizedBox(width: 15),
                        _listIte('KCCL'),
                        const SizedBox(width: 15),
                        _listIte('KVBL'),
                        const SizedBox(width: 15),
                        _listIte('KCBL'),
                        const SizedBox(width: 15),
                        _listIte('NEWS'),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        );
      });

  Builder _slider(List<dynamic> list) => Builder(builder: (context) {
        if (list.isNotEmpty) {
          return CarouselSlider(
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: list
                .map((item) => MaterialButton(
                      onPressed: () {
                        context.launchLink(item['action_url']);
                      },
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Image.network(
                              (item['media_url'])
                                  .toString()
                                  .replaceAll('https', 'http'),
                              fit: BoxFit.cover,
                              width: 1000)),
                    ))
                .toList(),
          );
        } else {
          return Center(
            child: AppText.mediumText('No banners right now.'),
          );
        }
      });

  _listIte(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7),
        child: MaterialButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BroadbandView()));
          },
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(width: 1.5, color: AppColors.text),
          ),
          child: Column(
            children: [
              Image.asset(
                AppIcons.shares,
                width: 35,
              ),
              const SizedBox(height: 5),
              AppText.mediumText(title, color: AppColors.primary)
            ],
          ),
        ),
      );
}
