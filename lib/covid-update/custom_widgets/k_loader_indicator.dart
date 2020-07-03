import 'package:covid_invasion/localization/lang_constant.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class KLoader extends StatelessWidget {
  const KLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/virus.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 120,
                  child: FlareActor('assets/animation/covid-19-loading.flr', alignment: Alignment.center, fit: BoxFit.contain, animation: 'Loading'),
                ),
                Text(getTranslated(context, 'loading.message')),
              ],
            ),
          ),

          // Center(
          //   child: CircularProgressIndicator(
          //     backgroundColor: Theme.of(context).primaryColor,
          //   ),
          // )
        ],
      ),
    );
  }
}
