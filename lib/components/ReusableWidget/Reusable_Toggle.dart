//todo:- Reusable Toggle switch
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:sizer/sizer.dart';

class ToggleSwitch extends StatefulWidget {
  final List<String> options;
  final Function(int) onChanged;

  ToggleSwitch({required this.options, required this.onChanged});

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(

        height: 5.h,
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(30),
          fillColor: Constants.primary,
          selectedColor: Colors.white,
          color: Colors.black,
          isSelected: List.generate(widget.options.length, (index) => index == _selectedIndex),
          onPressed: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            widget.onChanged(index);
          },
          children: widget.options.map((option) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(option,),
          )).toList(),
        ),
      ),
    );
  }
}
