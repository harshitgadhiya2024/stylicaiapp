import 'dart:convert';
/// data : {"bio":"","dob":"22-04-2025","email":"","first_name":"harshiy","gender":"Male","is_active":true,"is_email":false,"is_phone":true,"is_profile":false,"is_vehicle":false,"is_verified":false,"password":"Har@#0401","phone_number":"+91 9316727742","profile_url":"","type":"email","user_id":"2060a205-3d14-4116-b03d-98bec029d14b","vehicle_details":{}}
/// status : 200
/// timestamp : "04-22-2025 06:16:19"

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      Data? data, 
      num? status, 
      String? timestamp,}){
    _data = data;
    _status = status;
    _timestamp = timestamp;
}

  UserModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _status = json['status'];
    _timestamp = json['timestamp'];
  }
  Data? _data;
  num? _status;
  String? _timestamp;
UserModel copyWith({  Data? data,
  num? status,
  String? timestamp,
}) => UserModel(  data: data ?? _data,
  status: status ?? _status,
  timestamp: timestamp ?? _timestamp,
);
  Data? get data => _data;
  num? get status => _status;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['status'] = _status;
    map['timestamp'] = _timestamp;
    return map;
  }

}

/// bio : ""
/// dob : "22-04-2025"
/// email : ""
/// first_name : "harshiy"
/// gender : "Male"
/// is_active : true
/// is_email : false
/// is_phone : true
/// is_profile : false
/// is_vehicle : false
/// is_verified : false
/// password : "Har@#0401"
/// phone_number : "+91 9316727742"
/// profile_url : ""
/// type : "email"
/// user_id : "2060a205-3d14-4116-b03d-98bec029d14b"
/// vehicle_details : {}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? bio, 
      String? dob, 
      String? email, 
      String? firstName, 
      String? gender, 
      bool? isActive, 
      bool? isEmail, 
      bool? isPhone, 
      bool? isProfile, 
      bool? isVehicle, 
      bool? isVerified, 
      String? password, 
      String? phoneNumber, 
      String? profileUrl, 
      String? type, 
      String? userId, 
      dynamic vehicleDetails,}){
    _bio = bio;
    _dob = dob;
    _email = email;
    _firstName = firstName;
    _gender = gender;
    _isActive = isActive;
    _isEmail = isEmail;
    _isPhone = isPhone;
    _isProfile = isProfile;
    _isVehicle = isVehicle;
    _isVerified = isVerified;
    _password = password;
    _phoneNumber = phoneNumber;
    _profileUrl = profileUrl;
    _type = type;
    _userId = userId;
    _vehicleDetails = vehicleDetails;
}

  Data.fromJson(dynamic json) {
    _bio = json['bio'];
    _dob = json['dob'];
    _email = json['email'];
    _firstName = json['first_name'];
    _gender = json['gender'];
    _isActive = json['is_active'];
    _isEmail = json['is_email'];
    _isPhone = json['is_phone'];
    _isProfile = json['is_profile'];
    _isVehicle = json['is_vehicle'];
    _isVerified = json['is_verified'];
    _password = json['password'];
    _phoneNumber = json['phone_number'];
    _profileUrl = json['profile_url'];
    _type = json['type'];
    _userId = json['user_id'];
    _vehicleDetails = json['vehicle_details'];
  }
  String? _bio;
  String? _dob;
  String? _email;
  String? _firstName;
  String? _gender;
  bool? _isActive;
  bool? _isEmail;
  bool? _isPhone;
  bool? _isProfile;
  bool? _isVehicle;
  bool? _isVerified;
  String? _password;
  String? _phoneNumber;
  String? _profileUrl;
  String? _type;
  String? _userId;
  dynamic _vehicleDetails;
Data copyWith({  String? bio,
  String? dob,
  String? email,
  String? firstName,
  String? gender,
  bool? isActive,
  bool? isEmail,
  bool? isPhone,
  bool? isProfile,
  bool? isVehicle,
  bool? isVerified,
  String? password,
  String? phoneNumber,
  String? profileUrl,
  String? type,
  String? userId,
  dynamic vehicleDetails,
}) => Data(  bio: bio ?? _bio,
  dob: dob ?? _dob,
  email: email ?? _email,
  firstName: firstName ?? _firstName,
  gender: gender ?? _gender,
  isActive: isActive ?? _isActive,
  isEmail: isEmail ?? _isEmail,
  isPhone: isPhone ?? _isPhone,
  isProfile: isProfile ?? _isProfile,
  isVehicle: isVehicle ?? _isVehicle,
  isVerified: isVerified ?? _isVerified,
  password: password ?? _password,
  phoneNumber: phoneNumber ?? _phoneNumber,
  profileUrl: profileUrl ?? _profileUrl,
  type: type ?? _type,
  userId: userId ?? _userId,
  vehicleDetails: vehicleDetails ?? _vehicleDetails,
);
  String? get bio => _bio;
  String? get dob => _dob;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get gender => _gender;
  bool? get isActive => _isActive;
  bool? get isEmail => _isEmail;
  bool? get isPhone => _isPhone;
  bool? get isProfile => _isProfile;
  bool? get isVehicle => _isVehicle;
  bool? get isVerified => _isVerified;
  String? get password => _password;
  String? get phoneNumber => _phoneNumber;
  String? get profileUrl => _profileUrl;
  String? get type => _type;
  String? get userId => _userId;
  dynamic get vehicleDetails => _vehicleDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bio'] = _bio;
    map['dob'] = _dob;
    map['email'] = _email;
    map['first_name'] = _firstName;
    map['gender'] = _gender;
    map['is_active'] = _isActive;
    map['is_email'] = _isEmail;
    map['is_phone'] = _isPhone;
    map['is_profile'] = _isProfile;
    map['is_vehicle'] = _isVehicle;
    map['is_verified'] = _isVerified;
    map['password'] = _password;
    map['phone_number'] = _phoneNumber;
    map['profile_url'] = _profileUrl;
    map['type'] = _type;
    map['user_id'] = _userId;
    map['vehicle_details'] = _vehicleDetails;
    return map;
  }

}