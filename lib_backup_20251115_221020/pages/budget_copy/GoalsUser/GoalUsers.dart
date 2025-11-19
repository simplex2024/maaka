// ignore_for_file: prefer_interpolation_to_compose_strings, invalid_return_type_for_catch_error, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../components/constants.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_util.dart';
import '../BudgetCopyController.dart';
import '../Goals/UserGoalHistory.dart';
import 'GoalUsersNotifier.dart';

class UserGoals extends ConsumerStatefulWidget {
  const UserGoals({Key? key}) : super(key: key);

  @override
  UserGoalsState createState() => UserGoalsState();
}

class UserGoalsState extends ConsumerState<UserGoals> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // await isGoalFound();
      ref.read(userGoalListProvider.notifier).getUserGoalDetails();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primary,
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              automaticallyImplyLeading: false,
              toolbarHeight: 100,
              title: Text("Users With Goals",style:
              TextStyle(color: Constants.secondary,)),
              centerTitle: false,
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Consumer(builder: (context, ref, child) {
          UsrGoalsState getUserGlList = ref.watch(userGoalListProvider);

          bool isLoading = false;

          isLoading = (getUserGlList.status == ResStatus.loading);

          return Stack(children: [
            Container(
              color: Colors.white,
              height: 100.h,
              child: Stack(
                children: [
                  CustomScrollView(slivers: [
                    SliverLayoutBuilder(
                      builder: (BuildContext context,
                          SliverConstraints constraints) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final document = getUserGlList.success?[index];

                              final name = document?.name ?? "";
                              final mobile = document?.mobile ?? "";
                              final securityCode =
                                  document?.getSecurityCode ?? "";
                              final total = document?.getNetBal();
                              final interest = document?.getNetIntBal();
                              final getAdminType = document?.getAdminType;
                              final isGoalsAdded = document?.isUserSetupGoals;

                              String? getDocId = document?.docId;
                              bool? isMoneyRequest = document?.isMoneyRequest;
                              double? requestAmnt = document?.requestAmount;
                              double? requestCashbckAmnt =
                                  document?.requestCashbckAmount;

                              bool? isNotificationByAdmin =
                                  document?.isNotificationByAdmin;

                              String getFinInt = interest == null
                                  ? 0.0.toString()
                                  : interest.toStringAsFixed(2);

                              String? getUserToken = document?.notificationToken;

                              return Container(
                                color: Colors.white.withOpacity(0.95),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: ListTile(
                                        leading: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                elevation: 6.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        title: Text(
                                          name.toString().toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Color(0xFF004D40),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              letterSpacing: 0.5),
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$mobile',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.5)),
                                          ],
                                        ),
                                        trailing: Container(
                                          width: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text('$total' + ' ₹',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Color(0xFF004D40),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.5)),
                                              Text('$getFinInt' + ' ₹',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.5)),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserGoalHistory(
                                                      getDocId:
                                                      getDocId,
                                                      getMobile:
                                                      mobile,
                                                      getNetBal:
                                                      total,
                                                      getUserName: name
                                                          .toString(),
                                                      getUserToken: getUserToken ?? "",
                                                    ),
                                              )).then((value) {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: getUserGlList?.success?.length ?? 0,
                          ),
                        );
                      },
                    ),

                  ]),
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    )),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
