
abstract class ApiResponse<T>{
  T? get data;
  String? get errorMessage;
}

class Success<T> extends ApiResponse<T>{
  final T? _data;
  Success(this._data);

  @override
  T? get data => _data;
  
  @override
  
  String? get errorMessage => "";
  }

class Failure<T> extends ApiResponse<T>{
  final String? _errorMessage;
  Failure(this._errorMessage);


  @override
  T? get data => null;
  
  @override
  String? get errorMessage => _errorMessage;}