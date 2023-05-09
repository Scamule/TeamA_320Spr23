extension BoolParsing on String {
  parseBool() {
    return toLowerCase() == "true";
  }
}
