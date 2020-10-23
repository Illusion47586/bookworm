String compressTextTitle(String text, {int maxLen = 25}) {
  String tempText = text;
  if (text.length > maxLen) {
    tempText = text.substring(0, maxLen - 3) + "...";
  }
  return tempText;
}
