import 'package:intl/intl.dart';
import 'package:patient_flutter/generated/l10n.dart';
import 'package:patient_flutter/model/custom/categories.dart';
import 'package:patient_flutter/utils/update_res.dart';

extension A on int {
  String get number {
    return NumberFormat.compactCurrency(
            decimalDigits: 0, locale: 'en_US', name: '')
        .format(this)
        .toString();
  }

  String get numFormat {
    return NumberFormat(numberFormat).format(this);
  }
}

extension H on double {
  String get numFormat {
    return NumberFormat(numberFormat).format(this);
  }
}

extension B on String {
  String dateMilliFormat(String formatKey) {
    return DateFormat(formatKey, 'en')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(this)).toLocal());
  }

  String dateParse(String formatKey) {
    return DateFormat(formatKey, 'en').format(DateTime.parse(this).toLocal());
  }
}

extension C on DateTime {
  String formatDateTime(String formatKey) {
    return DateFormat(formatKey, 'en').format(this);
  }
}

extension O on PrescriptionMedical {
  static final RegExp removeEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  List<List<String>> getMedicines() {
    List<List<String>> medicalData = [];
    addMedicine?.forEach((element) {
      List<String> temp = [];
      temp.add(
          '${element.title} ${element.notes == null || element.notes!.isEmpty ? '' : removeEmoji.hasMatch(element.notes ?? '') ? '' : '\n${S.current.notes} :-${element.notes ?? ''}'} ');
      temp.add(
          element.mealTime == 0 ? S.current.afterMeal : S.current.beforeMeal);
      temp.add('${element.dosage}');
      temp.add('${element.quantity}');
      medicalData.add(temp);
    });
    return medicalData;
  }
}
