bool isEmptyString(String input) {
  if (input == '' || input.isEmpty) {
    return true;
  }
  return false;
}

String emptyStringPlaceholder(String input, String returnTxt) {
  if (input == '' || input.isEmpty) {
    return returnTxt;
  }
  return input;
}
