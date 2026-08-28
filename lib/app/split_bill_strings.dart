import '../domain/split_bill_models.dart';
import 'split_bill_state.dart';

class SplitStrings {
  const SplitStrings(this.language);

  final AppLanguage language;

  bool get isEnglish => language == AppLanguage.en;

  String get appTitle => 'Split Bill';
  String get bills => isEnglish ? 'Bills' : 'Bill';
  String get settings => isEnglish ? 'Settings' : 'Pengaturan';
  String get newBill => isEnglish ? 'New Bill' : 'Bill Baru';
  String get equalSplit => isEnglish ? 'Equal Split' : 'Split Rata';
  String get custom => 'Custom';
  String get perItem => isEnglish ? 'By Items' : 'Per Item';
  String get languageLabel => isEnglish ? 'Language' : 'Bahasa';
  String get theme => isEnglish ? 'Theme' : 'Tema';
  String get system => 'System';
  String get light => isEnglish ? 'Light' : 'Terang';
  String get dark => isEnglish ? 'Dark' : 'Gelap';
  String get indonesia => 'Indonesia';
  String get english => 'English';
  String get homeIntro => isEnglish ? 'Split bills offline.' : 'Bagi tagihan offline.';
  String get newBillIntro => isEnglish ? 'Add people, items, and charges.' : 'Tambah orang, item, dan biaya.';
  String get recentBills => isEnglish ? 'Recent Bills' : 'Riwayat';
  String get noBillsTitle => isEnglish ? 'No saved bills' : 'Belum ada bill';
  String get noBillsMessage => isEnglish ? 'Start with a new bill.' : 'Mulai dari bill baru.';
  String savedCount(int count) => isEnglish ? '$count saved' : '$count tersimpan';
  String participantCount(int count) => isEnglish ? '$count people' : '$count orang';
  String get totalSaved => isEnglish ? 'Saved total' : 'Total tersimpan';
  String get localOnly => isEnglish ? 'Saved on this device.' : 'Tersimpan di perangkat ini.';
  String get chooseTheme => isEnglish ? 'Choose display mode.' : 'Pilih tampilan.';
  String get chooseLanguage => isEnglish ? 'Choose app language.' : 'Pilih bahasa aplikasi.';

  String modeLabel(SplitMode mode) {
    return switch (mode) {
      SplitMode.equal => equalSplit,
      SplitMode.items => perItem,
      SplitMode.custom => custom,
    };
  }

  String modeDescription(SplitMode mode) {
    return switch (mode) {
      SplitMode.equal => isEnglish ? 'Split the total evenly.' : 'Bagi total sama rata.',
      SplitMode.items => isEnglish ? 'Assign items to people.' : 'Tetapkan item ke peserta.',
      SplitMode.custom => isEnglish ? 'Set each amount manually.' : 'Isi jumlah tiap peserta.',
    };
  }
}
