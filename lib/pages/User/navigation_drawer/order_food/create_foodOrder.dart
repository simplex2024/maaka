//todo:- shows details of selected product
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maaakanmoney/components/constants.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_theme.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_util.dart';
import 'package:maaakanmoney/flutter_flow/flutter_flow_widgets.dart';
import 'package:maaakanmoney/pages/budget_copy/ecommerce/ecommerce.dart';
import 'package:sizer/sizer.dart';

import 'food_summary.dart';

class FoodDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String affiliateLink;
  final String amount;
  final String minBargainAmount;
  final String prodDetails;
  final String prodSpec;
  final List<dynamic> imageUrls;
  final String userName;
  final String getAdminType;
  final String getHeroTag;

  FoodDetailScreen(
      {required this.title,
      required this.description,
      required this.affiliateLink,
      required this.prodDetails,
      required this.prodSpec,
      required this.imageUrls,
      required this.amount,
      required this.minBargainAmount,
      required this.userName,
      required this.getAdminType,
      required this.getHeroTag});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _currentPage = 0;

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final ScrollController _scrollController = ScrollController();

  String selectedArea = '';

  //initially pricing details for user shown based on retrieved pincode
  String selectedPincode = '';

  //now if user reffered by meat shop owner, pricing show based on details against user's mob no
  String getReffererMob = '';
  String selectedQuantity = '1 No'; // Default weight set to 1kg
  String? selectedChickenOption =
      'With Skin'; // Default chicken option set to With Skin
  double quantityInNos = 1; // Default weight in kg set to 1.0

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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Scaffold(
          backgroundColor: Constants.secondary,
          appBar: responsiveVisibility(
            context: context,
            tabletLandscape: false,
            desktop: false,
          )
              ? AppBar(
                  backgroundColor: Constants.secondary,
                  automaticallyImplyLeading: true,
                  toolbarHeight: 8.h,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.black),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                )
              : null,
          body: SafeArea(
            child: Container(
              height: 100.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.description,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(color: Constants.secondary3)),
                                Text(widget.title,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Constants.primary)),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Price\n",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      color: Constants.primary)),
                                          TextSpan(
                                            text: ' ₹' + widget.amount,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    color: Constants.secondary3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 35.h,
                                            width: 60.w,
                                            // Adjust height as needed
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // Rounded corners
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                //
                                                topLeft: Radius.circular(20),
                                              ),
                                              child: Stack(
                                                children: [
                                                  PageView.builder(
                                                    itemCount:
                                                        widget.imageUrls.length,
                                                    onPageChanged: (int page) {
                                                      setState(() {
                                                        _currentPage = page;
                                                      });
                                                    },
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullImageScreen(
                                                                imageUrl: widget
                                                                        .imageUrls[
                                                                    index],
                                                                heroTag:
                                                                    'image_$index',
                                                                affiliateLink: widget
                                                                    .affiliateLink,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Hero(
                                                          tag: widget.getHeroTag,
                                                          child: Image.network(
                                                            widget
                                                                .imageUrls[index],
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              } else {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress
                                                                                .expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress
                                                                                .cumulativeBytesLoaded /
                                                                            loadingProgress
                                                                                .expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 0,
                                                    right: 0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children:
                                                          List<Widget>.generate(
                                                        widget.imageUrls.length,
                                                        (int index) {
                                                          return Container(
                                                            width: 8,
                                                            height: 8,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color:
                                                                  _currentPage ==
                                                                          index
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .grey,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(
                                          fontFamily:
                                          'Encode Sans Condensed',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(
                                        15), // Circular corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Select Quantity",
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
                                            borderRadius: BorderRadius.circular(10), // Smooth rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.4), // Soft shadow color
                                                blurRadius: 8, // Smooth blur effect
                                                spreadRadius: 2, // Slight spread
                                                offset: Offset(2, 4), // Light bottom-right shadow
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          child: DropdownButtonFormField<String>(
                                            value: selectedQuantity,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            items: [
                                              '1 No',
                                              '2 No',
                                              '3 No',
                                              '4 No',
                                              '5 No',
                                            ]
                                                .map((weight) => DropdownMenuItem(
                                                      value: weight,
                                                      child: Text(weight),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  selectedQuantity = value;
                                                  quantityInNos = _convertQuantityToNo(value);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery Details',
                                      style: TextStyle(
                                          fontFamily:
                                          'Encode Sans Condensed',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color
                                    borderRadius: BorderRadius.circular(
                                        15), // Circular corners
                                  ),
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
                                            borderRadius: BorderRadius.circular(10), // Smooth rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.4), // Soft shadow color
                                                blurRadius: 8, // Smooth blur effect
                                                spreadRadius: 2, // Slight spread
                                                offset: Offset(2, 4), // Light bottom-right shadow
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          child: TextField(
                                              controller: dateController,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.calendar_today),
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
                                                  .bodyMedium
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
                                            borderRadius: BorderRadius.circular(10), // Smooth rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.4), // Soft shadow color
                                                blurRadius: 8, // Smooth blur effect
                                                spreadRadius: 2, // Slight spread
                                                offset: Offset(2, 4), // Light bottom-right shadow
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  _buildTotalPriceItem(
                                    'Total Price for $selectedQuantity',
                                    _calculateTotalPrice(double.tryParse(widget.amount) ?? 0.0, quantityInNos),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      if (widget.title == null ||
                                          selectedQuantity == null ||
                                          selectedChickenOption == null ||
                                          pickedDate == null ||
                                          pickedTime == null) {
                                        print("fill all details");
                                        return;
                                      }

                                      if(widget.title == null || selectedChickenOption == null || pickedDate == null || pickedTime == null){
                                        print("fill all details");
                                        return;
                                      }


                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FoodSummaryScreen(
                                            title: widget.title,
                                            selectedArea: selectedArea,
                                            totalPrice: _calculateTotalPrice(double.tryParse(widget.amount) ?? 0.0, quantityInNos),
                                            selectedDate: pickedDate ?? DateTime.now(),
                                            selectedTime: pickedTime ?? "", selectedQuantity: selectedQuantity,
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
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: Constants.colorFoodCPrimary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily: 'Outfit',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },
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

  double _convertQuantityToNo(String quantity) {
    switch (quantity) {
      case '1 No':
        return 1;
      case '2 No':
        return 2;
      case '3 No':
        return 3;
      case '4 No':
        return 4;
      case '5 No':
        return 5;
      default:
        return 1;
    }
  }

  Widget _buildTotalPriceItem(String itemName, dynamic price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$itemName: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              '₹ ${price.toStringAsFixed(2)}',
              style:
              Theme.of(context)
                  .textTheme
                  .headlineLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalPrice(double price, double weightInNos) {

      final pricePerItem = price ?? 0.0;
      return pricePerItem * weightInNos;

  }
}
