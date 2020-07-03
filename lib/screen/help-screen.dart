import 'package:covid_invasion/localization/lang_constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key key}) : super(key: key);
  // Widget sepatator(){
  //   return
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 48.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(child: Container()),
                      Text(
                        getTranslated(context, 'helpscreen.title'),
                        style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                separator(),
                Row(
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'helpscreen.developer'),
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.developedBy')),
                    Text('Dan Tong'),
                  ],
                ),
                separator(),
                Row(
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'helpscreen.thanksTo'),
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.sound')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://freesound.org/',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://freesound.org/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.imagesFrom')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://www.freepik.com',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://www.freepik.com';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.iconsFrom')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://thenounproject.com',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://thenounproject.com';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.animationFrom')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://lottiefiles.com/',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://lottiefiles.com/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.animationFrom')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://rive.app/',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://rive.app/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                separator(),
                Row(
                  children: <Widget>[
                    Text(
                      getTranslated(context, 'helpscreen.officialCovidInfo'),
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.whoWebsite')),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'https://www.who.int/',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://www.who.int/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(getTranslated(context, 'helpscreen.covidDataResources')),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.fade,
                        softWrap: true,
                        maxLines: 2,
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'https://www.worldometers.info/coronavirus/',
                              style: new TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = 'https://www.worldometers.info/coronavirus/';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                separator(),
                Text(
                  getTranslated(context, 'helpscreen.howToPlayGame'),
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: getTranslated(context, 'helpscreen.playGameInstruction'),
                            style: new TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 2,
        color: Colors.grey.shade200,
      ),
    );
  }
}
