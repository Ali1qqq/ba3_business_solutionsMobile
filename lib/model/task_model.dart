class TaskModel {
  String? taskId;
  String? taskProductId;
  String? taskType;
  String? taskInventory;
  String? taskDate;
  bool? isTaskAvailable;
  int? taskQuantity;
  List<String> taskSellerListId = [];

  TaskModel({this.taskId , this.taskProductId ,  this.taskQuantity,this.taskType,this.taskInventory,this.taskDate});

  TaskModel.fromJson(json){
    taskId = json['taskId'];
    taskProductId = json['taskProductId'];
    taskQuantity = json['taskQuantity'];
    taskType = json['taskType'];
    taskInventory = json['taskInventory'];
    taskDate = json['taskDate'];
    DateTime date = DateTime(int.parse(taskDate!.split("-")[0]),int.parse(taskDate!.split("-")[1]));
    DateTime now = DateTime.now();
    if(date.month ==now.month && date.year ==now.year ){
      isTaskAvailable = true;
    }else{
      isTaskAvailable = false;
    }
    taskSellerListId = json['taskSellerListId'].map((e)=>e.toString()).cast<String>().toList() ;
  }

  toJson(){
    return {
      "taskId":taskId,
      "taskProductId":taskProductId,
      "taskQuantity":taskQuantity,
      "taskSellerListId":taskSellerListId,
      "taskInventory":taskInventory,
      "taskDate":taskDate,
      "taskType":taskType,
    };
  }

}