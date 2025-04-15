import 'dart:math';

extension StringExtension on String? {
  bool get isNullOrEmpty {
    if (this == null) return true;
    return (this!.isEmpty);
  }

  String toCapitalized() {
    return this![0].toUpperCase() + (this?.substring(1) ?? '');
  }

  String convertMedia() {
    const originalDomain = "https://file.mentor.vn/";
    const newDomain = "https://file.mentor.vn/";
    var x = this?.replaceAll(originalDomain, newDomain);
    return x ?? '';
  }

  String addHttpsPrefix() {
    // if (!this!.startsWith("https://file.mentor.vn")) {
    //   return "https://file.mentor.vn" + this!;
    // }
    return this!;
  }

  String replaceHalfWithUnderscore() {
    String input = this ?? '';
    if (input.isEmpty) return input;

    final random = Random();
    // Chuyển đổi String thành List để dễ dàng thao tác
    final inputChars = input.split('');
    final length = inputChars.length;

    // Tạo danh sách các vị trí ngẫu nhiên
    final positions = List.generate(length, (index) => index)..shuffle(random);

    // Lấy một nửa độ dài danh sách các vị trí
    final halfLength = (length / 2).floor();

    for (int i = 0; i < halfLength; i++) {
      inputChars[positions[i]] = '_';
    }

    return inputChars.join('');
  }

  double get formatScore {
    final array = (this ?? '').split('/');
    return double.parse(array[0]) / double.parse(array[1]);
  }

  String get submitAnswer {
    final List<dynamic> list = (this ?? '').split('\\');
    return list.join();
  }

  String get capitalizeFirstLetter {
    final input = this ?? '';
    if (input.isEmpty) return input;
    // Tách chuỗi thành các từ bằng dấu cách
    List<String> words = input.split(' ');

    // Viết hoa chữ cái đầu của mỗi từ
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).toList();

    // Ghép lại các từ thành một chuỗi
    return capitalizedWords.join(' ');
  }

  String get capitalizeFirstLetterFirstWord {
    final input = this ?? '';
    if (input.isEmpty) return input;

    // Viết hoa chữ cái đầu
    String output = input[0].toUpperCase() + input.substring(1).toLowerCase();
    return output;
  }

  String get removeSpacesAroundDash {
    final input = this ?? '';
    if (input.isEmpty) return input;
    String result = input.replaceAll(RegExp(r'\s*-\s*'), '-');
    return result;
  }

  String get removeSpecialCharacter {
    // Sử dụng regex để thay thế tất cả các ký tự không phải chữ cái, số hoặc khoảng trắng
    final input = this ?? '';
    if (input.isEmpty) return input;
    String result = input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    return result;
  }

  /// Lấy từ cuối cùng sau dấu cách
  String get lastWord {
    if (isNullOrEmpty) return '';
    String valueName = this!.trim();
    int lastSpaceIndex = valueName.lastIndexOf(' ');
    if (lastSpaceIndex == -1) {
      return this!; // Nếu không có dấu cách, trả về toàn bộ chuỗi
    }
    return valueName
        .substring(lastSpaceIndex + 1)
        .trim(); // Lấy chuỗi sau dấu cách cuối cùng
  }

  //Lấy chuỗi sau dấu bằng
  String? valueAfterEqualSign() {
    final input = this ?? '';
    final index = input.indexOf('=');
    if (index != -1 && index + 1 < input.length) {
      return input.substring(index + 1);
    }
    return null; // Trả về null nếu không tìm thấy dấu `=` hoặc không có giá trị sau đó.
  }

  String? getLastPathSegment() {
    final uri = Uri.tryParse(this ?? '');
    if (uri != null) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    }
    return null;
  }

  String? getLastSegment() {
    final input = this ?? '';
    final segments = input.split('/');
    return segments.isNotEmpty ? segments.last : null;
  }

  //oại bỏ các khoảng trắng
  String? removeExtraSpaces() {
    return this?.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String hideCharacters({double percentHide = 1}) {
    String input = this ?? '';
    if (input.isEmpty) return input;
    percentHide = percentHide.clamp(0, 1);

    int totalToHide = (input.length * percentHide).round();
    Set<int> indexesToHide = {};

    Random random = Random();
    while (indexesToHide.length < totalToHide) {
      indexesToHide.add(random.nextInt(input.length));
    }

    return String.fromCharCodes(input.runes.map((char) {
      return indexesToHide.contains(input.runes.toList().indexOf(char))
          ? '_'.codeUnitAt(0)
          : char;
    }));
  }

  String maskWords({double percent = 1, String previousMaskedString = ''}) {
    String input = this ?? '';
    if (input.isEmpty || percent == 1) return input;

    List<String> words = input
        .split(RegExp(r'[^a-zA-Z0-9*]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    int maskedCount = (words.length * (1 - percent)).round();

    List<int> maskedIndexes = [];
    Random random = Random();

    if (previousMaskedString.isEmpty) {
      while (maskedIndexes.length < maskedCount) {
        int index = random.nextInt(words.length);
        if (!maskedIndexes.contains(index)) {
          maskedIndexes.add(index);
        }
      }
    } else {
      ///
      // Xác định từ nào đã bị che trong previousMaskedString
      List<String> prevWords = previousMaskedString
          .split(RegExp(r'(\s+|[^a-zA-Z0-9_]+)'))
          .where((e) => e.isNotEmpty)
          .toList();

      List<int> prevMaskedIndexes = [];
      for (int i = 0; i < prevWords.length; i++) {
        if (prevWords[i].contains('_')) {
          prevMaskedIndexes.add(i);
        }
      }

      ///
      // Nếu số lượng từ bị che trước đó nhiều hơn mức cần che hiện tại, mở bớt từ
      if (prevMaskedIndexes.length > maskedCount) {
        prevMaskedIndexes.shuffle();
        prevMaskedIndexes = prevMaskedIndexes.sublist(0, maskedCount);
      }
      maskedIndexes = prevMaskedIndexes;

      // Nếu cần che thêm từ, chọn ngẫu nhiên từ chưa bị che
      while (maskedIndexes.length < maskedCount) {
        int index = random.nextInt(words.length);
        if (!maskedIndexes.contains(index)) {
          maskedIndexes.add(index);
        }
      }
    }

    int wordIndex = 0;
    return input.splitMapJoin(
      // Biểu thức chính quy này tách chuỗi thành các từ hoặc ký tự đặc biệt riêng biệt.
      RegExp(r'[a-zA-Z0-9]+|[^a-zA-Z0-9]+'),
      onMatch: (match) {
        String part = match.group(0)!; // Lấy phần khớp trong chuỗi gốc.

        // Kiểm tra xem phần này có phải là một từ (chỉ chứa chữ cái hoặc số) hay không.
        bool isWord = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(part);

        if (isWord) {
          bool shouldMask = maskedIndexes
              .contains(wordIndex); // Kiểm tra từ này có cần che không.
          wordIndex++; // Tăng chỉ mục từ lên để theo dõi vị trí.

          // Nếu cần che, thay thế toàn bộ ký tự của từ đó thành "_"
          return shouldMask ? '_' * part.length : part;
        }
        return part;
      },
    );
  }
}
