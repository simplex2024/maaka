import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class OptionBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required List<Tuple2<String, String>> options,
    required String title,
    required Function(String) onSelect,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isScrollControlled: true, // Allows custom height control
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // Expands up to half the screen height
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                options[index].item1,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                options[index].item2,
                                style: TextStyle(fontSize: 16,),
                                textAlign: TextAlign.end,

                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          onSelect(options[index].item2);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
