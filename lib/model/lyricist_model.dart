class LyricistModel{
final int id;
final String name;
final String nateRasulsCount;
LyricistModel({required this.id, required this.name, required this.nateRasulsCount});

factory LyricistModel.fromJson(Map<String,dynamic> json){
return  LyricistModel(
  id: json['id'],
  name: json['name'],
  nateRasulsCount: json['nate_rasuls_count']?.toString()?? '0',
  
  
  );


}

  get profileImage => null;





}