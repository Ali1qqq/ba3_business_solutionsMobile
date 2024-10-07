import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../model/user_model.dart';

class TimerView extends StatefulWidget {
  final String oldKey;
  const TimerView({super.key, required this.oldKey});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late StopWatchTimer _stopWatchTimer;
  UserManagementViewModel userManagementViewModel = Get.find<UserManagementViewModel>();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
    );
    // _stopWatchTimer.secondTime.listen((event) {
    //   HiveDataBase.timerTimeBox.put("time", event);
    // });
    UserModel userModel= userManagementViewModel.allUserList[widget.oldKey]!;
    int totalSec = 0;
    bool isClosed =false;
    if(userModel.userTimeList?.length ==userModel.userDateList?.length ){
     isClosed = true;
    }
    for (var i  = 0 ; i < (userModel.userDateList?.length ?? 0); i++) {
      DateTime date =userModel.userDateList![i];
      int time = userModel.userTimeList!.elementAtOrNull(i)??0;
      if(DateTime.now().toString().split(" ")[0] == date.toString().split(" ")[0]){
        totalSec += time;
      }else{
      }
    }
    if(isClosed){

    }else {
      if(userModel.userDateList!.last.toString().split(" ")[0] ==DateTime.now().toString().split(" ")[0]){
        totalSec += DateTime.now().difference(userModel.userDateList!.last).inSeconds;
      }else{
          int customTime = DateTime.parse(DateTime.now().toString().split(" ")[0]).difference(userModel.userDateList!.last).inSeconds;
          userManagementViewModel.startTimeReport(userId: getMyUserUserId(),customDate: DateTime.parse(DateTime.now().toString().split(" ")[0]));
          userManagementViewModel.sendTimeReport(userId: getMyUserUserId(),customTime: customTime);
          totalSec += (DateTime.now().difference(DateTime.parse(DateTime.now().toString().split(" ")[0]))).inSeconds;
      }
      _stopWatchTimer.onStartTimer();
    }
    _stopWatchTimer.setPresetSecondTime(totalSec);
    // if( HiveDataBase.timerDateBox.get("date")==DateTime.now().toString().split(" ")[0]){
    //   UserTimeRecord data = userManagementViewModel.allUserList[widget.oldKey]!.userTimeRecord!.where((element) => element.date == HiveDataBase.timerDateBox.get("date")).first;
    //  if(data.isOpen!){
    //    _stopWatchTimer.setPresetSecondTime(DateTime.now().difference(data.startTime!).inSeconds+int.parse(data.time??"0"));
    //    _stopWatchTimer.onStartTimer();
    //  }else{
    //    _stopWatchTimer.setPresetSecondTime(int.parse(data.time!));
    //    _stopWatchTimer.onStopTimer();
    //  }
    // }else{
    //   HiveDataBase.timerDateBox.put("date",DateTime.now().toString().split(" ")[0]);
    // }
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BackButton(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 100,
                          child: Text(
                            "المؤقت",
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                          )),
                      StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          final value = snap.data!;
                          final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
                          return Column(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 400,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    displayTime,
                                    style: const TextStyle(fontSize: 40, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(45),
                        onTap: _stopWatchTimer.isRunning
                            ? () {
                                _stopWatchTimer.onStopTimer();
                                userManagementViewModel.sendTimeReport(userId: widget.oldKey);
                                setState(() {});
                              }
                            : () {
                                _stopWatchTimer.onStartTimer();
                                userManagementViewModel.startTimeReport(userId: widget.oldKey);
                                setState(() {});
                              },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          child: Icon(
                            _stopWatchTimer.isRunning ? Icons.stop : Icons.play_arrow,
                            size: 50,
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
      ),
    );
  }
}
