import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';

enum AppBarType { basic, gradient, withProfile, withLocation }

class GlobalAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final AppBarType type;
  final List<Widget>? actions;

  const GlobalAppBar({
    Key? key,
    required this.title,
    this.type = AppBarType.basic,
    this.actions,
  }) : super(key: key);

  @override
  _GlobalAppBarState createState() => _GlobalAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GlobalAppBarState extends State<GlobalAppBar> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AppBarType.basic:
        return AppBar(
          title: Text(widget.title),
          actions: widget.actions,
        );

      case AppBarType.gradient:
        return AppBar(
          title: Text(widget.title),
          actions: widget.actions,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        );

      case AppBarType.withProfile:
        return AppBar(
          title: Text(widget.title),
          actions: [
            ...?widget.actions,
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage:
                NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
          ],
        );

      case AppBarType.withLocation:
        return AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Constants.colorFoodCSecondaryGrey2,
                    shape: BoxShape.circle,
                  ),
                  child:  Icon(Icons.location_on, color: Constants.colorFoodCPrimary),
                ),

              ],
            ),
          ),
          title: Text(widget.title,style: GlobalTextStyles.secondaryText2(
              textColor: FlutterFlowTheme.of(context).primary,
              txtWeight: FontWeight.normal),),
          centerTitle: false,
          actions: [
            // ...?widget.actions,
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Constants.colorFoodCSecondaryGrey2,
                  shape: BoxShape.circle,
                ),
                child:   Icon(Icons.person, color: Constants.colorFoodCPrimary),
              ),
            ),
          ],
        );
    }
  }
}