import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_crafts_ph/classes/class_loading_info.dart';

class ScreenLoading extends StatefulWidget {
  @override
  _ScreenLoadingState createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;

    LoadingInfo li = LoadingInfo.launchInfo;
    if (args is LoadingInfo) li = args;

    if (!processing) {
      loadingProcess(context, li);
      processing = true;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/banner/checkerboard.png'),
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primaryVariant.withAlpha(20), BlendMode.modulate),
            fit: BoxFit.cover,
          ),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ClipOval(
                      child: ColorFiltered(
                          child: Image.asset('images/logo_white.png'),
                        colorFilter : ColorFilter.mode(Theme.of(context).colorScheme.secondary, BlendMode.modulate),
                      )
                  )
              ),
              SizedBox(height: 100.0),
              SpinKitCircle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 25.0),
              Text(
                li.loadingText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadingProcess(BuildContext context, LoadingInfo loadingInfo) async {
    await loadingInfo.func();

    if (loadingInfo.isReplacement)
      Navigator.pushReplacementNamed(context, loadingInfo.nextRouteNamed);
    else{
      Navigator.pop(context);
      Navigator.pushNamed(context, loadingInfo.nextRouteNamed);
    }
  }
}
