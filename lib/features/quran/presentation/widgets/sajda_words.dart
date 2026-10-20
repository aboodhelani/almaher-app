import '../../domain/models/ayah_model.dart';

/// The words lined over in the Madani mushaf for each of the 15 sajdas —
/// the words of the prostration — as word indexes [start, end) in the
/// ayah's text, read from the King Fahd Complex pages. The line is not
/// always in the ayah that ends with ۩ (16:49, 17:107, 27:25, 41:37).
const _sajdaWords = <String, (int, int)>{
  '7:206': (9, 11), // وَلَهُۥ يَسْجُدُونَ
  '13:15': (0, 2), // وَلِلَّهِ يَسْجُدُ
  '16:49': (0, 2), // وَلِلَّهِ يَسْجُدُ
  '17:107': (16, 19), // يَخِرُّونَ لِلْأَذْقَانِ سُجَّدًۭا
  '19:58': (27, 29), // خَرُّوا۟ سُجَّدًۭا
  '22:18': (4, 5), // يَسْجُدُ
  '22:77': (3, 5), // ٱرْكَعُوا۟ وَٱسْجُدُوا۟
  '25:60': (3, 5), // ٱسْجُدُوا۟ لِلرَّحْمَٰنِ
  '27:25': (0, 2), // أَلَّا يَسْجُدُوا۟
  '32:15': (7, 9), // خَرُّوا۟ سُجَّدًۭا
  '38:24': (31, 34), // وَخَرَّ رَاكِعًۭا وَأَنَابَ
  '41:37': (12, 16), // وَٱسْجُدُوا۟ لِلَّهِ ٱلَّذِى خَلَقَهُنَّ
  '53:62': (0, 2), // فَٱسْجُدُوا۟ لِلَّهِ
  '84:21': (4, 6), // لَا يَسْجُدُونَ
  '96:19': (3, 4), // وَٱسْجُدْ
};

/// The characters [start, end) of [ayah]'s text lined over as its sajda.
(int, int)? sajdaRange(AyahModel ayah) {
  final words = _sajdaWords[ayah.key];
  if (words == null) return null;
  final (first, last) = words;
  var start = -1;
  var index = 0;
  var pos = 0;
  for (final word in ayah.text.split(' ')) {
    if (index == first) start = pos;
    if (index == last - 1) return start < 0 ? null : (start, pos + word.length);
    pos += word.length + 1;
    index++;
  }
  return null;
}
