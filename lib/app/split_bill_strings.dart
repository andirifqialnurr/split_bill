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
  String get close => isEnglish ? 'Close' : 'Tutup';
  String get back => isEnglish ? 'Back' : 'Kembali';
  String get next => isEnglish ? 'Next' : 'Lanjut';
  String get save => isEnglish ? 'Save' : 'Simpan';
  String get saveBill => isEnglish ? 'Save Bill' : 'Simpan Bill';
  String get cancel => isEnglish ? 'Cancel' : 'Batal';
  String get remove => isEnglish ? 'Remove' : 'Hapus';
  String get editParticipant => isEnglish ? 'Edit participant' : 'Edit peserta';
  String get billDetail => isEnglish ? 'Bill detail' : 'Detail bill';
  String get title => isEnglish ? 'Title' : 'Judul';
  String get titleHint => isEnglish ? 'Dinner' : 'Makan malam';
  String get splitMode => isEnglish ? 'Split Mode' : 'Mode Split';
  String get people => isEnglish ? 'People' : 'Peserta';
  String get peopleIntro => isEnglish ? 'Add at least two people.' : 'Tambahkan minimal dua peserta.';
  String get nickname => isEnglish ? 'Nickname' : 'Nama';
  String get addPerson => isEnglish ? 'Add person' : 'Tambah peserta';
  String get noPeopleTitle => isEnglish ? 'No people yet' : 'Belum ada peserta';
  String get noPeopleMessage => isEnglish ? 'Add names one by one.' : 'Masukkan nama satu per satu.';
  String get items => isEnglish ? 'Items' : 'Item';
  String get itemsIntro => isEnglish ? 'Add items and assign people.' : 'Tambah item dan pilih peserta.';
  String get itemName => isEnglish ? 'Item name' : 'Nama item';
  String get itemHint => isEnglish ? 'Grilled chicken' : 'Ayam bakar';
  String get quantity => isEnglish ? 'Qty' : 'Qty';
  String get totalPrice => isEnglish ? 'Total price' : 'Total harga';
  String get addItem => isEnglish ? 'Add Item' : 'Tambah Item';
  String get noItemsTitle => isEnglish ? 'No items yet' : 'Belum ada item';
  String get noItemsMessage => isEnglish ? 'Add an item, then assign people.' : 'Tambah item, lalu pilih peserta.';
  String get deleteItem => isEnglish ? 'Delete item' : 'Hapus item';
  String get unassigned => isEnglish ? 'Unassigned' : 'Belum dipilih';
  String get selectAll => isEnglish ? 'Select All' : 'Pilih Semua';
  String get done => isEnglish ? 'Done' : 'Selesai';
  String get charges => isEnglish ? 'Charges' : 'Biaya';
  String get customAmount => isEnglish ? 'Custom Amount' : 'Jumlah Custom';
  String get chargesIntro => isEnglish ? 'Add tax, service, or discount.' : 'Isi pajak, layanan, atau diskon.';
  String get customIntro => isEnglish ? 'Set each person amount.' : 'Isi jumlah tiap peserta.';
  String get billTotal => isEnglish ? 'Bill total' : 'Total tagihan';
  String get totalToSplit => isEnglish ? 'Total to split' : 'Total dibagi';
  String get allocationOk => isEnglish ? 'Allocation is complete.' : 'Alokasi sudah pas.';
  String remainingAmount(String amount) => isEnglish ? 'Remaining $amount.' : 'Sisa $amount.';
  String get subtotal => 'Subtotal';
  String get subtotalFromItems => isEnglish ? 'Subtotal from items' : 'Subtotal dari item';
  String get tax => isEnglish ? 'Tax' : 'Pajak';
  String get service => isEnglish ? 'Service' : 'Layanan';
  String get discount => isEnglish ? 'Discount' : 'Diskon';
  String get grandTotal => 'Grand Total';
  String get none => isEnglish ? 'None' : 'Tidak ada';
  String get amount => isEnglish ? 'Amount' : 'Nominal';
  String get percent => isEnglish ? 'Percent' : 'Persen';
  String get summaryCopied => isEnglish ? 'Summary copied.' : 'Ringkasan disalin.';
  String get billSaved => isEnglish ? 'Bill saved.' : 'Bill tersimpan.';
  String get discardTitle => isEnglish ? 'Discard bill?' : 'Buang bill?';
  String get discardMessage => isEnglish ? 'Unsaved data will be removed.' : 'Data belum tersimpan akan hilang.';
  String get discard => isEnglish ? 'Discard' : 'Buang';
  String removeParticipantTitle(String name) => isEnglish ? 'Remove $name?' : 'Hapus $name?';
  String get removeParticipantMessage => isEnglish ? 'Assignments will be cleared.' : 'Assignment akan dibersihkan.';
  String get helperNeedPeople => isEnglish ? 'Add at least two people.' : 'Tambahkan minimal dua peserta.';
  String get helperNeedItems => isEnglish ? 'Add at least one item.' : 'Tambahkan minimal satu item.';
  String get helperNeedTotal => isEnglish ? 'Enter the bill total.' : 'Masukkan total tagihan.';
  String get helperNeedCustom => isEnglish ? 'Set remaining to zero.' : 'Selesaikan sisa ke Rp0.';

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
