import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_widgets.dart';
import 'package:maaakanmoney/pages/User/navigation_drawer/order_meat/order_summary.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

//  Map<String, Map<String, dynamic>> areaPricingData = {
//   'Area 1': {
//     'Chicken': {
//       'Area Price': {'With Skin': 210, 'Without Skin': 260},
//       'Our Price': {'With Skin': 190, 'Without Skin': 240},
//     },
//     'Mutton': {
//       'Area Price': 730,
//       'Our Price': 690,
//     },
//   },
//   'Area 2': {
//     'Chicken': {
//       'Area Price': {'With Skin': 220, 'Without Skin': 270},
//       'Our Price': {'With Skin': 200, 'Without Skin': 250},
//     },
//     'Mutton': {
//       'Area Price': 750,
//       'Our Price': 710,
//     },
//   },
//   'Area 3': {
//     'Chicken': {
//       'Area Price': {'With Skin': 230, 'Without Skin': 280},
//       'Our Price': {'With Skin': 210, 'Without Skin': 260},
//     },
//     'Mutton': {
//       'Area Price': 770,
//       'Our Price': 730,
//     },
//   },
// };
Map<String, Map<String, dynamic>> areaPricingData = {};

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DetailScreen extends StatefulWidget {
  final String title;
  final bool
      isReffererPricingPresent; //todo if yes , then user under meat shop owner or executive

  const DetailScreen(
      {Key? key, required this.title, required this.isReffererPricingPresent})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedArea = '';

  //initially pricing details for user shown based on retrieved pincode
  String selectedPincode = '';

  //now if user reffered by meat shop owner, pricing show based on details against user's mob no
  String getReffererMob = '';
  String selectedWeight = '1kg'; // Default weight set to 1kg
  String? selectedChickenOption =
      'With Skin'; // Default chicken option set to With Skin
  double weightInKg = 1.0; // Default weight in kg set to 1.0

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DateTime? pickedDate;
  String? pickedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedArea = Constants.getUserArea ?? "";
    selectedPincode = Constants.getUserPincode ?? "";
    getReffererMob = Constants.getRefferer ?? "";

    // Set the initial date to the current date
    final now = DateTime.now();
    dateController.text =
        DateFormat('dd-MM-yyyy').format(now); // Format: yyyy-MM-dd
    pickedDate = now;
    pickedTime = DateFormat('hh:mm a').format(DateTime.now());

    // Delay time initialization until the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        timeController.text =
            TimeOfDay.fromDateTime(now).format(context); // Format: hh:mm AM/PM
      });
    });

    getAreaPricingDetails();
  }

  Future<void> getAreaPricingDetails() async {
    try {
      areaPricingData = await fetchAreaPricingData();
      print(areaPricingData); // This will display the updated data structure.

      setState(() {});
    } catch (e) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CreateOrdrScreen(context, widget.isReffererPricingPresent ?? false);
  }

  // Widget _CreateOrdrScreen(BuildContext context, bool? isReffererPricingPresent,) {
  //
  //
  //
  //   if((isReffererPricingPresent ?? false) == true){
  //
  //
  //     //todo:- if user admin sets a meat price ,then get meat shop owner(refferer mob) pricing should shown to their users else price against  pincode  should shown
  //
  //     final isChicken = widget.title == 'Chicken';
  //     // final pricing = areaPricingData[(selectedArea ?? "")]?[widget.title]?? "";
  //
  //     return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Constants.colorMeatCPrimary,
  //         title: Text('${widget.title}',style: TextStyle(color: Constants.secondary),),
  //         leading: IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon:  Icon(Icons.arrow_back_ios_rounded,
  //               color:   Constants.secondary),
  //         ),
  //       ),
  //       body: FutureBuilder<Map<String, Map<String, dynamic>>>(
  //         future: fetchAreaPricingData(),
  //         builder: (BuildContext context, AsyncSnapshot<Map<String, Map<String, dynamic>>> snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Container(height: 100.h,child: Center(child: Text(
  //               "Loading...",
  //                   style: TextStyle(
  //                       letterSpacing: 2.5,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 )));
  //           } else if (snapshot.hasError) {
  //             return Center(child: Text('Error: ${snapshot.error}'));
  //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //             return Center(child: Text('No products found.'));
  //           }
  //
  //           areaPricingData = snapshot.data!;
  //
  //           final pricing = areaPricingData[(getReffererMob ?? "")]?[widget.title]?? "";
  //
  //           return Container(
  //             height: 100.h,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Expanded(
  //                     flex: 8,
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Check Price',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.circular(12),
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: Colors.grey.withOpacity(0.4),
  //                                     blurRadius: 8,
  //                                     spreadRadius: 2,
  //                                     offset: Offset(2, 4),
  //                                   )
  //                                 ],
  //                               ),
  //
  //
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Text(
  //                                           (isReffererPricingPresent ?? false) == true ? 'Market Price' : 'In $selectedArea',
  //                                           style: TextStyle( fontFamily:
  //                                           'Encode Sans Condensed',fontSize: 16, fontWeight: FontWeight.bold),
  //                                         ),
  //                                         Padding(
  //                                           padding:
  //                                           EdgeInsetsDirectional
  //                                               .fromSTEB(
  //                                               8.0,
  //                                               8.0,
  //                                               8.0,
  //                                               8.0),
  //                                           child: Icon(
  //                                             Icons.location_on,
  //                                             color: Colors.red,
  //                                             size: 24.0,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     SizedBox(height: 5),
  //                                     Text(
  //                                         "Price for ${widget.title}:",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     if (isChicken) ...[
  //                                       _buildPriceItem(
  //                                           'Chicken with Skin', pricing['Area Price']?['With Skin']),
  //                                       _buildPriceItem('Chicken without Skin',
  //                                           pricing['Area Price']?['Without Skin']),
  //                                     ] else ...[
  //                                       _buildPriceItem('Mutton', pricing['Area Price']),
  //                                     ],
  //
  //                                     SizedBox(height: 10),
  //                                     Text(
  //                                       'But We Offer it for Less!',
  //                                       style: TextStyle( fontFamily:
  //                                       'Encode Sans Condensed',color: Constants.secondary,fontSize: 15, fontWeight: FontWeight.bold,backgroundColor: Constants.colorMeatCPrimary),
  //                                     ),
  //                                     if (isChicken) ...[
  //                                       _buildPriceItem(
  //                                           'Chicken with Skin', pricing['Our Price']?['With Skin']),
  //                                       _buildPriceItem(
  //                                           'Chicken without Skin', pricing['Our Price']?['Without Skin']),
  //                                     ] else ...[
  //                                       _buildPriceItem('Mutton', pricing['Our Price']),
  //                                     ],
  //
  //                                     SizedBox(height: 20),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Meat Details',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white,
  //                               //   borderRadius: BorderRadius.circular(12),
  //                               //   boxShadow: [
  //                               //     BoxShadow(
  //                               //       color: Colors.grey.withOpacity(0.4),
  //                               //       blurRadius: 8,
  //                               //       spreadRadius: 2,
  //                               //       offset: Offset(2, 4),
  //                               //     )
  //                               //   ],
  //                               // ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                         "Select Weight",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //
  //                                     SizedBox(height: 10),
  //                                     // DropdownButtonFormField<String>(
  //                                     //   value: selectedWeight,
  //                                     //   decoration: InputDecoration(
  //                                     //
  //                                     //     border: OutlineInputBorder(),
  //                                     //   ),
  //                                     //   items: [
  //                                     //     '100g',
  //                                     //     '250g',
  //                                     //     '300g',
  //                                     //     '500g',
  //                                     //     '750g',
  //                                     //     '1kg',
  //                                     //     '1.5kg',
  //                                     //     '2kg',
  //                                     //     '2.5kg',
  //                                     //     '3kg',
  //                                     //     '5kg',
  //                                     //     '10kg'
  //                                     //   ]
  //                                     //       .map((weight) => DropdownMenuItem(
  //                                     //     value: weight,
  //                                     //     child: Text(weight),
  //                                     //   ))
  //                                     //       .toList(),
  //                                     //   onChanged: (value) {
  //                                     //     if (value != null) {
  //                                     //       setState(() {
  //                                     //         selectedWeight = value;
  //                                     //         weightInKg = _convertWeightToKg(value);
  //                                     //       });
  //                                     //     }
  //                                     //   },
  //                                     // ),
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Padding for better UI
  //                                       child: DropdownButtonFormField<String>(
  //                                         value: selectedWeight,
  //                                         decoration: InputDecoration(
  //                                           border: InputBorder.none, // Removes the border
  //                                           contentPadding: EdgeInsets.symmetric(vertical: 8),
  //                                         ),
  //                                         items: [
  //                                           '100g', '250g', '300g', '500g', '750g',
  //                                           '1kg', '1.5kg', '2kg', '2.5kg', '3kg', '5kg', '10kg'
  //                                         ].map((weight) => DropdownMenuItem(
  //                                           value: weight,
  //                                           child: Text(weight),
  //                                         )).toList(),
  //                                         onChanged: (value) {
  //                                           if (value != null) {
  //                                             setState(() {
  //                                               selectedWeight = value;
  //                                               weightInKg = _convertWeightToKg(value);
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //
  //                                     isChicken ? SizedBox(height: 20) : SizedBox(height: 0),
  //                                     isChicken ? Text(
  //                                         "Select Chicken Option",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)): Container(),
  //                                     SizedBox(height: 10),
  //                                     isChicken ?
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: DropdownButtonFormField<String>(
  //                                         value: selectedChickenOption,
  //                                         decoration: InputDecoration(
  //
  //                                           border: InputBorder.none,
  //                                         ),
  //                                         items: ['With Skin', 'Without Skin']
  //                                             .map((option) => DropdownMenuItem(
  //                                           value: option,
  //                                           child: Text(option),
  //                                         ))
  //                                             .toList(),
  //                                         onChanged: (value) {
  //                                           if (value != null) {
  //                                             setState(() {
  //                                               selectedChickenOption = value;
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ) : Container(),
  //                                     isChicken ? SizedBox(height: 20) : SizedBox(height: 0),
  //
  //
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Delivery Details',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white,
  //                               //   borderRadius: BorderRadius.circular(12),
  //                               //   boxShadow: [
  //                               //     BoxShadow(
  //                               //       color: Colors.grey.withOpacity(0.4),
  //                               //       blurRadius: 8,
  //                               //       spreadRadius: 2,
  //                               //       offset: Offset(2, 4),
  //                               //     )
  //                               //   ],
  //                               // ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //
  //                                     Text(
  //                                         "Select Delivery Date",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     SizedBox(height: 10),// TextField for selecting date
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: TextField(
  //                                           controller: dateController,
  //                                           decoration: InputDecoration(
  //
  //                                             suffixIcon: IconButton(
  //                                               icon: Icon(Icons.calendar_today),
  //                                               onPressed: () => _selectDate(context),
  //                                             ),
  //                                             border: InputBorder.none,
  //                                           ),
  //                                           readOnly: true, // Prevent manual input
  //                                           onTap: () {
  //                                             _selectDate(context);
  //                                           },
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .bodyLarge
  //                                               ?.copyWith( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
  //                                       ),
  //                                     ),
  //                                     SizedBox(height: 20),
  //
  //                                     Text(
  //                                         "Select Delivery Time",
  //                                         style:Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     SizedBox(height: 10),
  //
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: TextField(
  //                                           controller: timeController,
  //                                           decoration: InputDecoration(
  //
  //                                             suffixIcon: IconButton(
  //                                               icon: Icon(Icons.access_time),
  //                                               onPressed: () => _selectTime(context),
  //                                             ),
  //                                             border: InputBorder.none,
  //                                           ),
  //                                           readOnly: true,
  //                                           onTap: () {
  //                                             _selectTime(context);
  //                                           }, // Prevent manual input
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .bodyLarge
  //                                               ?.copyWith( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //
  //
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 2,
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         children: [
  //                           SizedBox(height: 10),
  //                           _buildTotalPriceItem(
  //                             'Total Price for $selectedWeight',
  //                             _calculateTotalPrice(pricing['Our Price'], weightInKg),
  //                           ),
  //                           Align(
  //                             alignment: const AlignmentDirectional(0.0, 0.05),
  //                             child: Padding(
  //                               padding: const EdgeInsetsDirectional.fromSTEB(
  //                                   0.0, 24.0, 0.0, 0.0),
  //                               child: FFButtonWidget(
  //                                 onPressed: (){
  //
  //                                   if(widget.title == null || selectedWeight ==null || selectedChickenOption == null || pickedDate == null || pickedTime == null){
  //                                     print("fill all details");
  //                                     return;
  //                                   }
  //
  //
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) => OrderSummaryScreen(
  //                                         title: widget.title,
  //                                         selectedArea: selectedArea,
  //                                         selectedWeight: selectedWeight,
  //                                         selectedChickenOption: selectedChickenOption,
  //                                         totalPrice: _calculateTotalPrice(
  //                                             pricing['Our Price'], weightInKg),
  //                                         selectedDate: pickedDate ?? DateTime.now(),
  //                                         selectedTime: pickedTime ?? "",isReffererPricingPresent: widget.isReffererPricingPresent ?? false,
  //                                       ),
  //                                     ),
  //                                   ).then((value) {
  //                                     Navigator.pop(context);
  //                                   });
  //                                 },
  //                                 text: "Order Now !",
  //                                 options: FFButtonOptions(
  //                                   width: 270.0,
  //                                   height: 50.0,
  //                                   padding: const EdgeInsetsDirectional.fromSTEB(
  //                                       0.0, 0.0, 0.0, 0.0),
  //                                   iconPadding:
  //                                   const EdgeInsetsDirectional.fromSTEB(
  //                                       0.0, 0.0, 0.0, 0.0),
  //                                   color: Constants.colorMeatCPrimary,
  //                                   textStyle: FlutterFlowTheme.of(context)
  //                                       .titleMedium
  //                                       .override(
  //                                     fontFamily:
  //                                     'Encode Sans Condensed',
  //                                     color: Colors.white,
  //                                     fontSize: 18.0,
  //                                     fontWeight: FontWeight.normal,
  //
  //                                   ),
  //                                   elevation: 2.0,
  //                                   borderSide: const BorderSide(
  //                                     color: Colors.transparent,
  //                                     width: 1.0,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(12.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //
  //     );
  //
  //   }else{
  //     final isChicken = widget.title == 'Chicken';
  //     // final pricing = areaPricingData[(selectedArea ?? "")]?[widget.title]?? "";
  //
  //     return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Constants.secondary4,
  //         title: Text('${widget.title}',style: TextStyle( fontFamily:
  //         'Encode Sans Condensed',color: Constants.secondary),),
  //         leading: IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon:  Icon(Icons.arrow_back_ios_rounded,
  //               color:   Constants.secondary),
  //         ),
  //       ),
  //       body: FutureBuilder<Map<String, Map<String, dynamic>>>(
  //         future: fetchAreaPricingData(),
  //         builder: (BuildContext context, AsyncSnapshot<Map<String, Map<String, dynamic>>> snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Container(height: 100.h,child: Center(child: CircularProgressIndicator()));
  //           } else if (snapshot.hasError) {
  //             return Center(child: Text('Error: ${snapshot.error}'));
  //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //             return Center(child: Text('No products found.'));
  //           }
  //
  //           areaPricingData = snapshot.data!;
  //
  //           final pricing = areaPricingData[(selectedPincode ?? "")]?[widget.title]?? "";
  //
  //           return Container(
  //             height: 100.h,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 children: [
  //                   Expanded(
  //                     flex: 8,
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Check Price',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.circular(12),
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: Colors.grey.withOpacity(0.4),
  //                                     blurRadius: 10,
  //                                     spreadRadius: 3,
  //                                   )
  //                                 ],
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Text(
  //                                           'In $selectedArea',
  //                                           style: TextStyle( fontFamily:
  //                                           'Encode Sans Condensed',fontSize: 16, fontWeight: FontWeight.bold),
  //                                         ),
  //                                         Padding(
  //                                           padding:
  //                                           EdgeInsetsDirectional
  //                                               .fromSTEB(
  //                                               8.0,
  //                                               8.0,
  //                                               8.0,
  //                                               8.0),
  //                                           child: Icon(
  //                                             Icons.location_on,
  //                                             color: Colors.red,
  //                                             size: 24.0,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     SizedBox(height: 5),
  //                                     Text(
  //                                         "Price for ${widget.title}:",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     if (isChicken) ...[
  //                                       _buildPriceItem(
  //                                           'Chicken with Skin', pricing['Area Price']?['With Skin']),
  //                                       _buildPriceItem('Chicken without Skin',
  //                                           pricing['Area Price']?['Without Skin']),
  //                                     ] else ...[
  //                                       _buildPriceItem('Mutton', pricing['Area Price']),
  //                                     ],
  //
  //                                     SizedBox(height: 10),
  //                                     Text(
  //                                       'But We Offer it for Less!',
  //                                       style: TextStyle( fontFamily:
  //                                       'Encode Sans Condensed',fontSize: 16, fontWeight: FontWeight.bold),
  //                                     ),
  //                                     if (isChicken) ...[
  //                                       _buildPriceItem(
  //                                           'Chicken with Skin', pricing['Our Price']?['With Skin']),
  //                                       _buildPriceItem(
  //                                           'Chicken without Skin', pricing['Our Price']?['Without Skin']),
  //                                     ] else ...[
  //                                       _buildPriceItem('Mutton', pricing['Our Price']),
  //                                     ],
  //
  //                                     SizedBox(height: 20),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Meat Details',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white,
  //                               //   borderRadius: BorderRadius.circular(12),
  //                               //   boxShadow: [
  //                               //     BoxShadow(
  //                               //       color: Colors.grey.withOpacity(0.4),
  //                               //       blurRadius: 10,
  //                               //       spreadRadius: 3,
  //                               //     )
  //                               //   ],
  //                               // ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                         "Select Weight",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //
  //                                     SizedBox(height: 10),
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: DropdownButtonFormField<String>(
  //                                         value: selectedWeight,
  //                                         decoration: InputDecoration(
  //
  //                                           border: InputBorder.none,
  //                                         ),
  //                                         items: [
  //                                           '100g',
  //                                           '250g',
  //                                           '300g',
  //                                           '500g',
  //                                           '750g',
  //                                           '1kg',
  //                                           '1.5kg',
  //                                           '2kg',
  //                                           '2.5kg',
  //                                           '3kg',
  //                                           '5kg',
  //                                           '10kg'
  //                                         ]
  //                                             .map((weight) => DropdownMenuItem(
  //                                           value: weight,
  //                                           child: Text(weight),
  //                                         ))
  //                                             .toList(),
  //                                         onChanged: (value) {
  //                                           if (value != null) {
  //                                             setState(() {
  //                                               selectedWeight = value;
  //                                               weightInKg = _convertWeightToKg(value);
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ),
  //
  //                                     isChicken ? SizedBox(height: 20) : SizedBox(height: 0),
  //                                     isChicken ? Text(
  //                                         "Select Chicken Option",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)): Container(),
  //                                     SizedBox(height: 10),
  //                                     isChicken ?
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: DropdownButtonFormField<String>(
  //                                         value: selectedChickenOption,
  //                                         decoration: InputDecoration(
  //
  //                                           border: InputBorder.none,
  //                                         ),
  //                                         items: ['With Skin', 'Without Skin']
  //                                             .map((option) => DropdownMenuItem(
  //                                           value: option,
  //                                           child: Text(option),
  //                                         ))
  //                                             .toList(),
  //                                         onChanged: (value) {
  //                                           if (value != null) {
  //                                             setState(() {
  //                                               selectedChickenOption = value;
  //                                             });
  //                                           }
  //                                         },
  //                                       ),
  //                                     ) : Container(),
  //                                     isChicken ? SizedBox(height: 20) : SizedBox(height: 0),
  //
  //
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 'Delivery Details',
  //                                 style: TextStyle( fontFamily:
  //                                 'Encode Sans Condensed',fontSize: 18, fontWeight: FontWeight.bold),
  //                               ),
  //
  //                             ],
  //                           ),
  //                           SizedBox(height: 5),
  //
  //                           Padding(
  //                             padding: const EdgeInsets.all(10.0),
  //                             child: Container(
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white, // Background color
  //                               //   borderRadius: BorderRadius.circular(15), // Circular corners
  //                               // ),
  //                               // decoration: BoxDecoration(
  //                               //   color: Colors.white,
  //                               //   borderRadius: BorderRadius.circular(12),
  //                               //   boxShadow: [
  //                               //     BoxShadow(
  //                               //       color: Colors.grey.withOpacity(0.4),
  //                               //       blurRadius: 10,
  //                               //       spreadRadius: 3,
  //                               //     )
  //                               //   ],
  //                               // ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //
  //                                     Text(
  //                                         "Select Delivery Date",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     SizedBox(height: 10),// TextField for selecting date
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: TextField(
  //                                           controller: dateController,
  //                                           decoration: InputDecoration(
  //
  //                                             suffixIcon: IconButton(
  //                                               icon: Icon(Icons.calendar_today),
  //                                               onPressed: () => _selectDate(context),
  //                                             ),
  //                                             border: InputBorder.none,
  //                                           ),
  //                                           readOnly: true, // Prevent manual input
  //                                           onTap: () {
  //                                             _selectDate(context);
  //                                           },
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .bodyLarge
  //                                               ?.copyWith( fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
  //                                       ),
  //                                     ),
  //                                     SizedBox(height: 20),
  //
  //                                     Text(
  //                                         "Select Delivery Time",
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .bodyMedium
  //                                             ?.copyWith( fontFamily:
  //                                         'Encode Sans Condensed',fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
  //                                     SizedBox(height: 10),
  //
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(10), // Smooth rounded corners
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color: Colors.grey.withOpacity(0.4), // Soft shadow color
  //                                             blurRadius: 8, // Smooth blur effect
  //                                             spreadRadius: 2, // Slight spread
  //                                             offset: Offset(2, 4), // Light bottom-right shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                                       child: TextField(
  //                                           controller: timeController,
  //                                           decoration: InputDecoration(
  //
  //                                             suffixIcon: IconButton(
  //                                               icon: Icon(Icons.access_time),
  //                                               onPressed: () => _selectTime(context),
  //                                             ),
  //                                             border: InputBorder.none,
  //                                           ),
  //                                           readOnly: true,
  //                                           onTap: () {
  //                                             _selectTime(context);
  //                                           }, // Prevent manual input
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .bodyLarge
  //                                               ?.copyWith(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //
  //
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 2,
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         children: [
  //                           SizedBox(height: 10),
  //                           _buildTotalPriceItem(
  //                             'Total Price for $selectedWeight',
  //                             _calculateTotalPrice(pricing['Our Price'], weightInKg),
  //                           ),
  //                           Align(
  //                             alignment: const AlignmentDirectional(0.0, 0.05),
  //                             child: Padding(
  //                               padding: const EdgeInsetsDirectional.fromSTEB(
  //                                   0.0, 24.0, 0.0, 0.0),
  //                               child: FFButtonWidget(
  //                                 onPressed: (){
  //
  //                                   if(widget.title == null || selectedWeight ==null || selectedChickenOption == null || pickedDate == null || pickedTime == null){
  //                                     print("fill all details");
  //                                     return;
  //                                   }
  //
  //
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) => OrderSummaryScreen(
  //                                         title: widget.title,
  //                                         selectedArea: selectedArea,
  //                                         selectedWeight: selectedWeight,
  //                                         selectedChickenOption: selectedChickenOption,
  //                                         totalPrice: _calculateTotalPrice(
  //                                             pricing['Our Price'], weightInKg),
  //                                         selectedDate: pickedDate ?? DateTime.now(),
  //                                         selectedTime: pickedTime ?? "",isReffererPricingPresent: widget.isReffererPricingPresent ?? false,
  //                                       ),
  //                                     ),
  //                                   ).then((value) {
  //                                     Navigator.pop(context);
  //                                   });
  //                                 },
  //                                 text: "Order Now !",
  //                                 options: FFButtonOptions(
  //                                   width: 270.0,
  //                                   height: 50.0,
  //                                   padding: const EdgeInsetsDirectional.fromSTEB(
  //                                       0.0, 0.0, 0.0, 0.0),
  //                                   iconPadding:
  //                                   const EdgeInsetsDirectional.fromSTEB(
  //                                       0.0, 0.0, 0.0, 0.0),
  //                                   color: Constants.secondary4,
  //                                   textStyle: FlutterFlowTheme.of(context)
  //                                       .titleMedium
  //                                       .override(
  //                                     fontFamily:
  //                                     'Encode Sans Condensed',
  //                                     color: Colors.white,
  //                                     fontSize: 18.0,
  //                                     fontWeight: FontWeight.normal,
  //                                   ),
  //                                   elevation: 2.0,
  //                                   borderSide: const BorderSide(
  //                                     color: Colors.transparent,
  //                                     width: 1.0,
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(12.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //
  //     );
  //   }
  // }

  //todo- 29.3.25
  Widget _CreateOrdrScreen(
    BuildContext context,
    bool? isReffererPricingPresent,
  ) {
    if ((isReffererPricingPresent ?? false) == true) {
      final List<Map<String, String>> chickenMeatTypes = [
        {'title': 'Chicken', 'image': 'images/chickn1.png'},
        {'title': 'Chicken Boneless', 'image': 'images/chickn1.png'},
        {'title': 'Chicken Leg Piece', 'image': 'images/chickn1.png'},
        {'title': 'Chicken Chest Piece', 'image': 'images/chickn1.png'},
      ];

      final List<Map<String, String>> muttonMeatTypes = [
        {'title': 'Mutton', 'image': 'images/muttn1.png'},
        {'title': 'Mutton Liver', 'image': 'images/muttn1.png'},
        {'title': 'Mutton Bone less', 'image': 'images/muttn1.png'},
      ];

      //todo:- if user admin sets a meat price ,then get meat shop owner(refferer mob) pricing should shown to their users else price against  pincode  should shown

      // final isChicken = widget.title == 'Chicken';

      MeatType getMeatType = widget.title == 'Chicken'
          ? MeatType.chicken
          : widget.title == 'ChickenBoneless'
              ? MeatType.chickenBoneless
              : widget.title == 'ChickenLegPiece'
                  ? MeatType.chickenLegPiece
                  : widget.title == 'ChickenChestPiece'
                      ? MeatType.chickenChestPiece
                      : widget.title == 'Mutton'
                          ? MeatType.mutton
                          : widget.title == 'MuttonLiver'
                              ? MeatType.muttonLiver
                              : widget.title == 'MuttonBoneless'
                                  ? MeatType.muttonBoneless
                                  : MeatType.mutton;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.colorMeatCPrimary,
          title: Text(
            '${widget.title}',
            style: TextStyle(color: Constants.secondary),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [ Constants.secondary4,Constants.colorMeatCPrimary,
                ] ,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(Icons.arrow_back_ios_rounded, color: Constants.secondary),
          ),
        ),
        body: FutureBuilder<Map<String, Map<String, dynamic>>>(
          future: fetchAreaPricingData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: 100.h,
                  child: Center(
                      child: Text(
                    "Loading...",
                    style: TextStyle(
                        letterSpacing: 2.5,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            areaPricingData = snapshot.data!;

            final pricing =
                areaPricingData[(getReffererMob ?? "")]?[widget.title] ?? "";

            return Container(
              height: 100.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Check Price',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: Offset(2, 4),
                                    )
                                  ],
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (isReffererPricingPresent ??
                                                        false) ==
                                                    true
                                                ? 'Market Price'
                                                : 'In $selectedArea',
                                            style: TextStyle(
                                                fontFamily:
                                                    'Encode Sans Condensed',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 8.0, 8.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text("Price for ${widget.title}:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      if (getMeatType == MeatType.chicken) ...[
                                        _buildPriceItem(
                                            'Chicken with Skin',
                                            pricing['Area Price']
                                                ?['With Skin']),
                                        _buildPriceItem(
                                            'Chicken without Skin',
                                            pricing['Area Price']
                                                ?['Without Skin']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenBoneless) ...[
                                        _buildPriceItem('ChickenBoneless',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenChestPiece) ...[
                                        _buildPriceItem('ChickenChestPiece',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenLegPiece) ...[
                                        _buildPriceItem('ChickenLegPiece',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.mutton) ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.muttonBoneless) ...[
                                        _buildPriceItem('MuttonBoneless',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.muttonLiver) ...[
                                        _buildPriceItem('MuttonLiver',
                                            pricing['Area Price']),
                                      ] else ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Area Price']),
                                      ],
                                      SizedBox(height: 10),
                                      Text(
                                        'But We Offer it for Less!',
                                        style: TextStyle(
                                            fontFamily: 'Encode Sans Condensed',
                                            color: Constants.secondary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            backgroundColor:
                                                Constants.colorMeatCPrimary),
                                      ),
                                      if (getMeatType == MeatType.chicken) ...[
                                        _buildPriceItem('Chicken with Skin',
                                            pricing['Our Price']?['With Skin']),
                                        _buildPriceItem(
                                            'Chicken without Skin',
                                            pricing['Our Price']
                                                ?['Without Skin']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenBoneless) ...[
                                        _buildPriceItem(
                                            'ChickenBoneless', pricing['Our Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenChestPiece) ...[
                                        _buildPriceItem(
                                            'ChickenChestPiece', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.chickenLegPiece) ...[
                                        _buildPriceItem(
                                            'ChickenLegPiece', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.mutton) ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.muttonBoneless) ...[
                                        _buildPriceItem(
                                            'MuttonBoneless', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.muttonLiver) ...[
                                        _buildPriceItem(
                                            'MuttonLiver', pricing['Our Price']),
                                      ]else ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Our Price']),
                                      ],
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Meat Details',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius: BorderRadius.circular(12),
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.grey.withOpacity(0.4),
                                //       blurRadius: 8,
                                //       spreadRadius: 2,
                                //       offset: Offset(2, 4),
                                //     )
                                //   ],
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Weight",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),

                                      SizedBox(height: 10),
                                      // DropdownButtonFormField<String>(
                                      //   value: selectedWeight,
                                      //   decoration: InputDecoration(
                                      //
                                      //     border: OutlineInputBorder(),
                                      //   ),
                                      //   items: [
                                      //     '100g',
                                      //     '250g',
                                      //     '300g',
                                      //     '500g',
                                      //     '750g',
                                      //     '1kg',
                                      //     '1.5kg',
                                      //     '2kg',
                                      //     '2.5kg',
                                      //     '3kg',
                                      //     '5kg',
                                      //     '10kg'
                                      //   ]
                                      //       .map((weight) => DropdownMenuItem(
                                      //     value: weight,
                                      //     child: Text(weight),
                                      //   ))
                                      //       .toList(),
                                      //   onChanged: (value) {
                                      //     if (value != null) {
                                      //       setState(() {
                                      //         selectedWeight = value;
                                      //         weightInKg = _convertWeightToKg(value);
                                      //       });
                                      //     }
                                      //   },
                                      // ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        // Padding for better UI
                                        child: DropdownButtonFormField<String>(
                                          value: selectedWeight,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // Removes the border
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8),
                                          ),
                                          items: [
                                            '100g',
                                            '250g',
                                            '300g',
                                            '500g',
                                            '750g',
                                            '1kg',
                                            '1.5kg',
                                            '2kg',
                                            '2.5kg',
                                            '3kg',
                                            '5kg',
                                            '10kg'
                                          ]
                                              .map((weight) => DropdownMenuItem(
                                                    value: weight,
                                                    child: Text(weight),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                selectedWeight = value;
                                                weightInKg =
                                                    _convertWeightToKg(value);
                                              });
                                            }
                                          },
                                        ),
                                      ),

                                      (getMeatType == MeatType.chicken || getMeatType == MeatType.chickenLegPiece || getMeatType == MeatType.chickenChestPiece || getMeatType == MeatType.chickenBoneless)
                                          ? SizedBox(height: 20)
                                          : SizedBox(height: 0),
                                      getMeatType == MeatType.chicken
                                          ? Text("Select Chicken Option",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontFamily:
                                                          'Encode Sans Condensed',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis))
                                          : Container(),
                                      SizedBox(height: 10),
                                      getMeatType == MeatType.chicken
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(
                                                    10), // Smooth rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                    // Soft shadow color
                                                    blurRadius: 8,
                                                    // Smooth blur effect
                                                    spreadRadius: 2,
                                                    // Slight spread
                                                    offset: Offset(2,
                                                        4), // Light bottom-right shadow
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                value: selectedChickenOption,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                items: [
                                                  'With Skin',
                                                  'Without Skin'
                                                ]
                                                    .map((option) =>
                                                        DropdownMenuItem(
                                                          value: option,
                                                          child: Text(option),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      selectedChickenOption =
                                                          value;
                                                    });
                                                  }
                                                },
                                              ),
                                            )
                                          : Container(),
                                      (getMeatType == MeatType.chicken || getMeatType == MeatType.chickenLegPiece || getMeatType == MeatType.chickenChestPiece || getMeatType == MeatType.chickenBoneless)
                                          ? SizedBox(height: 20)
                                          : SizedBox(height: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Delivery Details',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius: BorderRadius.circular(12),
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.grey.withOpacity(0.4),
                                //       blurRadius: 8,
                                //       spreadRadius: 2,
                                //       offset: Offset(2, 4),
                                //     )
                                //   ],
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Delivery Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      SizedBox(height: 10),
                                      // TextField for selecting date
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                            controller: dateController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon:
                                                    Icon(Icons.calendar_today),
                                                onPressed: () =>
                                                    _selectDate(context),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            readOnly: true,
                                            // Prevent manual input
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                      ),
                                      SizedBox(height: 20),

                                      Text("Select Delivery Time",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      SizedBox(height: 10),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                            controller: timeController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.access_time),
                                                onPressed: () =>
                                                    _selectTime(context),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            readOnly: true,
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            // Prevent manual input
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
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
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            _buildTotalPriceItem(
                              'Total Price for $selectedWeight',
                              _calculateTotalPrice(
                                  pricing['Our Price'], weightInKg),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.05),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    if (widget.title == null ||
                                        selectedWeight == null ||
                                        selectedChickenOption == null ||
                                        pickedDate == null ||
                                        pickedTime == null) {
                                      print("fill all details");
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderSummaryScreen(
                                          title: widget.title,
                                          selectedArea: selectedArea,
                                          selectedWeight: selectedWeight,
                                          selectedChickenOption:
                                              selectedChickenOption,
                                          totalPrice: _calculateTotalPrice(
                                              pricing['Our Price'], weightInKg),
                                          selectedDate:
                                              pickedDate ?? DateTime.now(),
                                          selectedTime: pickedTime ?? "",
                                          isReffererPricingPresent:
                                              widget.isReffererPricingPresent ??
                                                  false,
                                        ),
                                      ),
                                    ).then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  text: "Order Now !",
                                  options: FFButtonOptions(
                                    width: 270.0,
                                    height: 50.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: Constants.colorMeatCPrimary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Encode Sans Condensed',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 2.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      // final isChicken = widget.title == 'Chicken';
      // final pricing = areaPricingData[(selectedArea ?? "")]?[widget.title]?? "";

      MeatType getMeatType = widget.title == 'Chicken'
          ? MeatType.chicken
          : widget.title == 'ChickenBoneless'
          ? MeatType.chickenBoneless
          : widget.title == 'ChickenLegPiece'
          ? MeatType.chickenLegPiece
          : widget.title == 'ChickenChestPiece'
          ? MeatType.chickenChestPiece
          : widget.title == 'Mutton'
          ? MeatType.mutton
          : widget.title == 'MuttonLiver'
          ? MeatType.muttonLiver
          : widget.title == 'MuttonBoneless'
          ? MeatType.muttonBoneless
          : MeatType.mutton;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.secondary4,
          title: Text(
            '${widget.title}',
            style: TextStyle(
                fontFamily: 'Encode Sans Condensed',
                color: Constants.secondary),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(Icons.arrow_back_ios_rounded, color: Constants.secondary),
          ),
        ),
        body: FutureBuilder<Map<String, Map<String, dynamic>>>(
          future: fetchAreaPricingData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: 100.h,
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            areaPricingData = snapshot.data!;

            final pricing =
                areaPricingData[((selectedPincode) ?? "600078")]?[widget.title] ?? "";

            return Container(
              height: 100.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Check Price',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 3,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'In $selectedArea',
                                            style: TextStyle(
                                                fontFamily:
                                                    'Encode Sans Condensed',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 8.0, 8.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text("Price for ${widget.title}:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      // if (isChicken) ...[
                                      //   _buildPriceItem(
                                      //       'Chicken with Skin',
                                      //       pricing['Area Price']
                                      //           ?['With Skin']),
                                      //   _buildPriceItem(
                                      //       'Chicken without Skin',
                                      //       pricing['Area Price']
                                      //           ?['Without Skin']),
                                      // ] else ...[
                                      //   _buildPriceItem(
                                      //       'Mutton', pricing['Area Price']),
                                      // ],


                                      if (getMeatType == MeatType.chicken) ...[
                                        _buildPriceItem(
                                            'Chicken with Skin',
                                            pricing['Area Price']
                                            ?['With Skin']),
                                        _buildPriceItem(
                                            'Chicken without Skin',
                                            pricing['Area Price']
                                            ?['Without Skin']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenBoneless) ...[
                                        _buildPriceItem('ChickenBoneless',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenChestPiece) ...[
                                        _buildPriceItem('ChickenChestPiece',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenLegPiece) ...[
                                        _buildPriceItem('ChickenLegPiece',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.mutton) ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.muttonBoneless) ...[
                                        _buildPriceItem('MuttonBoneless',
                                            pricing['Area Price']),
                                      ] else if (getMeatType ==
                                          MeatType.muttonLiver) ...[
                                        _buildPriceItem('MuttonLiver',
                                            pricing['Area Price']),
                                      ] else ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Area Price']),
                                      ],

                                      SizedBox(height: 10),
                                      Text(
                                        'But We Offer it for Less!',
                                        style: TextStyle(
                                            fontFamily: 'Encode Sans Condensed',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // if (isChicken) ...[
                                      //   _buildPriceItem('Chicken with Skin',
                                      //       pricing['Our Price']?['With Skin']),
                                      //   _buildPriceItem(
                                      //       'Chicken without Skin',
                                      //       pricing['Our Price']
                                      //           ?['Without Skin']),
                                      // ] else ...[
                                      //   _buildPriceItem(
                                      //       'Mutton', pricing['Our Price']),
                                      // ],
                                      if (getMeatType == MeatType.chicken) ...[
                                        _buildPriceItem('Chicken with Skin',
                                            pricing['Our Price']?['With Skin']),
                                        _buildPriceItem(
                                            'Chicken without Skin',
                                            pricing['Our Price']
                                            ?['Without Skin']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenBoneless) ...[
                                        _buildPriceItem(
                                            'ChickenBoneless', pricing['Our Price']),
                                      ] else if (getMeatType ==
                                          MeatType.chickenChestPiece) ...[
                                        _buildPriceItem(
                                            'ChickenChestPiece', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.chickenLegPiece) ...[
                                        _buildPriceItem(
                                            'ChickenLegPiece', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.mutton) ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.muttonBoneless) ...[
                                        _buildPriceItem(
                                            'MuttonBoneless', pricing['Our Price']),
                                      ]else if (getMeatType ==
                                          MeatType.muttonLiver) ...[
                                        _buildPriceItem(
                                            'MuttonLiver', pricing['Our Price']),
                                      ]else ...[
                                        _buildPriceItem(
                                            'Mutton', pricing['Our Price']),
                                      ],
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Meat Details',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius: BorderRadius.circular(12),
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.grey.withOpacity(0.4),
                                //       blurRadius: 10,
                                //       spreadRadius: 3,
                                //     )
                                //   ],
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Weight",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: DropdownButtonFormField<String>(
                                          value: selectedWeight,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          items: [
                                            '100g',
                                            '250g',
                                            '300g',
                                            '500g',
                                            '750g',
                                            '1kg',
                                            '1.5kg',
                                            '2kg',
                                            '2.5kg',
                                            '3kg',
                                            '5kg',
                                            '10kg'
                                          ]
                                              .map((weight) => DropdownMenuItem(
                                                    value: weight,
                                                    child: Text(weight),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                selectedWeight = value;
                                                weightInKg =
                                                    _convertWeightToKg(value);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      // isChicken
                                      //     ? SizedBox(height: 20)
                                      //     : SizedBox(height: 0),
                                      // isChicken
                                      //     ? Text("Select Chicken Option",
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .bodyMedium
                                      //             ?.copyWith(
                                      //                 fontFamily:
                                      //                     'Encode Sans Condensed',
                                      //                 fontWeight:
                                      //                     FontWeight.bold,
                                      //                 overflow: TextOverflow
                                      //                     .ellipsis))
                                      //     : Container(),
                                      // SizedBox(height: 10),
                                      // isChicken
                                      //     ? Container(
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.white,
                                      //           borderRadius: BorderRadius.circular(
                                      //               10), // Smooth rounded corners
                                      //           boxShadow: [
                                      //             BoxShadow(
                                      //               color: Colors.grey
                                      //                   .withOpacity(0.4),
                                      //               // Soft shadow color
                                      //               blurRadius: 8,
                                      //               // Smooth blur effect
                                      //               spreadRadius: 2,
                                      //               // Slight spread
                                      //               offset: Offset(2,
                                      //                   4), // Light bottom-right shadow
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 12, vertical: 4),
                                      //         child: DropdownButtonFormField<
                                      //             String>(
                                      //           value: selectedChickenOption,
                                      //           decoration: InputDecoration(
                                      //             border: InputBorder.none,
                                      //           ),
                                      //           items: [
                                      //             'With Skin',
                                      //             'Without Skin'
                                      //           ]
                                      //               .map((option) =>
                                      //                   DropdownMenuItem(
                                      //                     value: option,
                                      //                     child: Text(option),
                                      //                   ))
                                      //               .toList(),
                                      //           onChanged: (value) {
                                      //             if (value != null) {
                                      //               setState(() {
                                      //                 selectedChickenOption =
                                      //                     value;
                                      //               });
                                      //             }
                                      //           },
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // isChicken
                                      //     ? SizedBox(height: 20)
                                      //     : SizedBox(height: 0),

                                      (getMeatType == MeatType.chicken || getMeatType == MeatType.chickenLegPiece || getMeatType == MeatType.chickenChestPiece || getMeatType == MeatType.chickenBoneless)
                                          ? SizedBox(height: 20)
                                          : SizedBox(height: 0),
                                      getMeatType == MeatType.chicken
                                          ? Text("Select Chicken Option",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                              fontFamily:
                                              'Encode Sans Condensed',
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis))
                                          : Container(),
                                      SizedBox(height: 10),
                                      getMeatType == MeatType.chicken
                                          ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: DropdownButtonFormField<
                                            String>(
                                          value: selectedChickenOption,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          items: [
                                            'With Skin',
                                            'Without Skin'
                                          ]
                                              .map((option) =>
                                              DropdownMenuItem(
                                                value: option,
                                                child: Text(option),
                                              ))
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                selectedChickenOption =
                                                    value;
                                              });
                                            }
                                          },
                                        ),
                                      )
                                          : Container(),
                                      (getMeatType == MeatType.chicken || getMeatType == MeatType.chickenLegPiece || getMeatType == MeatType.chickenChestPiece || getMeatType == MeatType.chickenBoneless)
                                          ? SizedBox(height: 20)
                                          : SizedBox(height: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Delivery Details',
                                  style: TextStyle(
                                      fontFamily: 'Encode Sans Condensed',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.white, // Background color
                                //   borderRadius: BorderRadius.circular(15), // Circular corners
                                // ),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius: BorderRadius.circular(12),
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.grey.withOpacity(0.4),
                                //       blurRadius: 10,
                                //       spreadRadius: 3,
                                //     )
                                //   ],
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Delivery Date",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      SizedBox(height: 10),
                                      // TextField for selecting date
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                            controller: dateController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon:
                                                    Icon(Icons.calendar_today),
                                                onPressed: () =>
                                                    _selectDate(context),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            readOnly: true,
                                            // Prevent manual input
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                      ),
                                      SizedBox(height: 20),

                                      Text("Select Delivery Time",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontFamily:
                                                      'Encode Sans Condensed',
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                      SizedBox(height: 10),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              10), // Smooth rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              // Soft shadow color
                                              blurRadius: 8,
                                              // Smooth blur effect
                                              spreadRadius: 2,
                                              // Slight spread
                                              offset: Offset(2,
                                                  4), // Light bottom-right shadow
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                            controller: timeController,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.access_time),
                                                onPressed: () =>
                                                    _selectTime(context),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            readOnly: true,
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            // Prevent manual input
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
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
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            _buildTotalPriceItem(
                              'Total Price for $selectedWeight',
                              _calculateTotalPrice(
                                  pricing['Our Price'], weightInKg),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.05),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    if (widget.title == null ||
                                        selectedWeight == null ||
                                        selectedChickenOption == null ||
                                        pickedDate == null ||
                                        pickedTime == null) {
                                      print("fill all details");
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderSummaryScreen(
                                          title: widget.title,
                                          selectedArea: selectedArea,
                                          selectedWeight: selectedWeight,
                                          selectedChickenOption:
                                              selectedChickenOption,
                                          totalPrice: _calculateTotalPrice(
                                              pricing['Our Price'], weightInKg),
                                          selectedDate:
                                              pickedDate ?? DateTime.now(),
                                          selectedTime: pickedTime ?? "",
                                          isReffererPricingPresent:
                                              widget.isReffererPricingPresent ??
                                                  false,
                                        ),
                                      ),
                                    ).then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  text: "Order Now !",
                                  options: FFButtonOptions(
                                    width: 270.0,
                                    height: 50.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color: Constants.secondary4,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Encode Sans Condensed',
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 2.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  double _convertWeightToKg(String weight) {
    switch (weight) {
      case '100g':
        return 0.1;
      case '250g':
        return 0.25;
      case '300g':
        return 0.3;
      case '500g':
        return 0.5;
      case '750g':
        return 0.75;
      case '1kg':
        return 1.0;
      case '1.5kg':
        return 1.5;
      case '2kg':
        return 2.0;
      case '2.5kg':
        return 2.5;
      case '3kg':
        return 3.0;
      case '5kg':
        return 5.0;
      case '10kg':
        return 10.0;
      default:
        return 1.0;
    }
  }

  double _calculateTotalPrice(dynamic price, double weightInKg) {
    if (price is Map) {
      final pricePerKg = selectedChickenOption == 'With Skin'
          ? price['With Skin']
          : price['Without Skin'];
      return pricePerKg * weightInKg;
    } else {
      return price * weightInKg;
    }
  }

  Widget _buildPriceItem(String itemName, dynamic price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$itemName: ',
            ),
          ),
          Expanded(
            child: Text(
              '₹${price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Encode Sans Condensed',
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPriceItem(String itemName, dynamic price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$itemName: ',
            style: TextStyle(
                fontFamily: 'Encode Sans Condensed',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              '₹ ${price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Only allow current and future dates
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        final DateFormat formatter = DateFormat('dd-MM-yyyy');

        dateController.text =
            DateFormat('dd-MM-yyyy').format(picked); // Format: yyyy-MM-dd
        pickedDate = picked;

        // Format the date to dd-MM-yyyy
        String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
        print("Selected Date: $formattedDate");
      });
    }
  }

  // Function to select the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context); // Format: hh:mm AM/PM
        pickedTime = picked.format(context);
        print(picked.format(context));
      });
    }
  }

  Future<Map<String, Map<String, dynamic>>> fetchAreaPricingData() async {
    try {
      QuerySnapshot userSnapshot =
          await firestore.collection('AreaMeatPrices').get();

      Map<String, Map<String, dynamic>> areaPricingData = {};

      await Future.forEach(userSnapshot.docs, (doc) async {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String getareaPincode = doc.id;

        // Extracting chicken prices
        Map<String, dynamic>? chickenData = data[getareaPincode]?['Chicken'];
        String areaPriceChickenWithSkin =
            chickenData?['AreaPrice']?['WithSkin']?.toString() ?? "0";
        String areaPriceChickenWithoutSkin =
            chickenData?['AreaPrice']?['WithoutSkin']?.toString() ?? "0";
        String ourPriceChickenWithSkin =
            chickenData?['OurPrice']?['WithSkin']?.toString() ?? "0";
        String ourPriceChickenWithoutSkin =
            chickenData?['OurPrice']?['WithoutSkin']?.toString() ?? "0";

        // Extracting mutton prices
        Map<String, dynamic>? muttonData = data[getareaPincode]?['Mutton'];
        String areaPriceMutton = muttonData?['AreaPrice']?.toString() ?? "0";
        String ourPriceMutton = muttonData?['OurPrice']?.toString() ?? "0";

        //todo:- 29.3.25 - new implementation for meat types
        //todo:- chicken
        Map<String, dynamic>? ChickenBonelessData =
            data[getareaPincode]?['ChickenBoneless'];
        String areaPriceChickenBonelessData =
            ChickenBonelessData?['Area Price']?.toString() ?? "0";
        String ourPriceChickenBonelessData =
            ChickenBonelessData?['Our Price']?.toString() ?? "0";

        Map<String, dynamic>? ChickenChestPieceData =
            data[getareaPincode]?['ChickenChestPiece'];
        String areaPriceChickenChestPieceData =
            ChickenChestPieceData?['Area Price']?.toString() ?? "0";
        String ourPriceChickenChestPieceData =
            ChickenChestPieceData?['Our Price']?.toString() ?? "0";

        Map<String, dynamic>? ChickenLegPieceData =
            data[getareaPincode]?['ChickenLegPiece'];
        String areaPriceChickenLegPieceData =
            ChickenLegPieceData?['Area Price']?.toString() ?? "0";
        String ourPriceChickenLegPieceData =
            ChickenLegPieceData?['Our Price']?.toString() ?? "0";

        //todo:- mutton
        Map<String, dynamic>? MuttonBonelessData =
            data[getareaPincode]?['MuttonBoneless'];
        String areaPriceMuttonBonelessData =
            MuttonBonelessData?['Area Price']?.toString() ?? "0";
        String ourPriceMuttonBonelessData =
            MuttonBonelessData?['Our Price']?.toString() ?? "0";

        Map<String, dynamic>? MuttonLiverData =
            data[getareaPincode]?['MuttonLiver'];
        String areaPriceMuttonLiverData =
            MuttonLiverData?['Area Price']?.toString() ?? "0";
        String ourPriceMuttonLiverData =
            MuttonLiverData?['Our Price']?.toString() ?? "0";

        // Populating areaPricingData
        areaPricingData[getareaPincode] = {
          'Chicken': {
            'Area Price': {
              'With Skin': int.parse(areaPriceChickenWithSkin),
              'Without Skin': int.parse(areaPriceChickenWithoutSkin),
            },
            'Our Price': {
              'With Skin': int.parse(ourPriceChickenWithSkin),
              'Without Skin': int.parse(ourPriceChickenWithoutSkin),
            },
          },
          'Mutton': {
            'Area Price': int.parse(areaPriceMutton),
            'Our Price': int.parse(ourPriceMutton),
          },
          'ChickenBoneless': {
            'Area Price': int.parse(areaPriceChickenBonelessData),
            'Our Price': int.parse(ourPriceChickenBonelessData),
          },
          'ChickenChestPiece': {
            'Area Price': int.parse(areaPriceChickenChestPieceData),
            'Our Price': int.parse(ourPriceChickenChestPieceData),
          },
          'ChickenLegPiece': {
            'Area Price': int.parse(areaPriceChickenLegPieceData),
            'Our Price': int.parse(ourPriceChickenLegPieceData),
          },
          'MuttonBoneless': {
            'Area Price': int.parse(areaPriceMuttonBonelessData),
            'Our Price': int.parse(ourPriceMuttonBonelessData),
          },
          'MuttonLiver': {
            'Area Price': int.parse(areaPriceMuttonLiverData),
            'Our Price': int.parse(ourPriceMuttonLiverData),
          },
        };
      });

      return areaPricingData;
    } catch (e) {
      Constants.showToast("No Internet Connection", ToastGravity.BOTTOM);
      return Future.error("Failed to fetch area pricing data.");
    }
  }
}

enum MeatType {
  chicken,
  chickenBoneless,
  chickenLegPiece,
  chickenChestPiece,
  mutton,
  muttonLiver,
  muttonBoneless
}
