class Success implements Status {
  Object response;

  // Constructor for Success class
  Success({required this.response});
}

class Failure implements Status {
  int code;
  Object errorResponse;

  // Constructor for Failure class
  Failure({required this.code, required this.errorResponse});
}

// Abstract class Status
abstract class Status {}
