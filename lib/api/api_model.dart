class ApiResponse<T> {
  T? data;
  String? message;
  bool status;

  ApiResponse.error(this.message, {this.status = false});
  ApiResponse.data(this.data, {this.status = true});

  @override
  String toString() {
    return "Message : $message \n Data : $data";
  }
}
