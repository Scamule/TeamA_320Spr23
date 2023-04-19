class Success implements Status {
  Object response;

  Success({required this.response});
}

class Failure implements Status {
  int code;
  Object errorResponse;

  Failure({required this.code, required this.errorResponse});
}

abstract class Status {}
