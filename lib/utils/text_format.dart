/// Ubah teks jadi Title Case: huruf depan tiap kata dikapitalkan.
/// Contoh: "project ini" -> "Project Ini".
///
/// Sisa huruf di tiap kata dibiarkan apa adanya, jadi singkatan tetap aman
/// (mis. "API bug" -> "API Bug", bukan "Api Bug").
String toTitleCase(String input) {
  return input
      .split(' ')
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
