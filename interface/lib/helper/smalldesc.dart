//small description
String smallDescription(String description, {int length = 30}) {
  if (description.length > length) {
    return "${description.substring(0, length)} ...";
  } else {
    return description;
  }
}
