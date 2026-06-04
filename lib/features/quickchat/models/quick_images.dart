// Quick Chat görsel verisi
// Her QuickChatItem: görüntülenecek resim yolu + gönderilecek metin.
// Arayüzde yalnızca [imagePath] gösterilir; [name] liste bütünlüğü için tutulur.

const String _base = 'assets/quick-images/';

class QuickChatItem {
  final String name;
  final String imagePath;

  const QuickChatItem({required this.name, required this.imagePath});
}

// Matris: [section 0–5][page 0–6]
// quickChatItems[section][page] → QuickChatItem
const List<List<QuickChatItem>> quickChatItems = [
  // ── Section 0: Basic Needs ──────────────────────────────
  [
    QuickChatItem(name: 'Temel İhtiyaçlar',    imagePath: '${_base}basic-needs.png'),
    QuickChatItem(name: 'Yemek yemek istiyorum',  imagePath: '${_base}eat.png'),
    QuickChatItem(name: 'Evet',         imagePath: '${_base}yes.png'),
    QuickChatItem(name: 'Mutluyum',               imagePath: '${_base}happy.png'),
    QuickChatItem(name: 'Sıcak hissediyorum',     imagePath: '${_base}hot.png'),
    QuickChatItem(name: 'Dışarı çıkmak istiyorum',imagePath: '${_base}outside.png'),
    QuickChatItem(name: 'Ağrım var',              imagePath: '${_base}pain.png'),
  ],

  // ── Section 1: Basic Expressions ──────────────────────────
  [
    QuickChatItem(name: 'Temel İfadeler',      imagePath: '${_base}frequent.png'),
    QuickChatItem(name: 'Uyumak istiyorum',        imagePath: '${_base}sleepy.png'),
    QuickChatItem(name: 'Bilmiyorum',          imagePath: '${_base}question.png'),
    QuickChatItem(name: 'Üzgünüm',                imagePath: '${_base}sad.png'),
    QuickChatItem(name: 'Soğuk hissediyorum',      imagePath: '${_base}cold.png'),
    QuickChatItem(name: 'Gazete okumak istiyorum', imagePath: '${_base}newspaper.png'),
    QuickChatItem(name: 'Çok şiddetli ağrım var',  imagePath: '${_base}extreme-pain.png'),
  ],

  // ── Section 2: Emotions ─────────────────────────────────
  [
    QuickChatItem(name: 'Duygular',               imagePath: '${_base}emotions.png'),
    QuickChatItem(name: 'Tuvalete gitmek istiyorum', imagePath: '${_base}bathroom.png'),
    QuickChatItem(name: 'Hayır',          imagePath: '${_base}no.png'),
    QuickChatItem(name: 'Kızgınım',               imagePath: '${_base}angry.png'),
    QuickChatItem(name: 'Çok gürültü var',         imagePath: '${_base}noisy.png'),
    QuickChatItem(name: 'Müzik dinlemek istiyorum', imagePath: '${_base}music.png'),
    QuickChatItem(name: 'İlaçlarımı almam gerekiyor', imagePath: '${_base}pills.png'),
  ],

  // ── Section 3: Environment Control ─────────────────────
  [
    QuickChatItem(name: 'Ortam Kontrolü',          imagePath: '${_base}environment.png'),
    QuickChatItem(name: 'Su içmek istiyorum',       imagePath: '${_base}water.png'),
    QuickChatItem(name: 'Teşekkürler',           imagePath: '${_base}thanks.png'),
    QuickChatItem(name: 'Korkuyorum',               imagePath: '${_base}scared.png'),
    QuickChatItem(name: 'Çok aydınlık',             imagePath: '${_base}bright.png'),
    QuickChatItem(name: 'Televizyon izlemek istiyorum', imagePath: '${_base}tv.png'),
    QuickChatItem(name: 'Hastaneye gitmem gerekiyor', imagePath: '${_base}hospital.png'),
  ],

  // ── Section 4: Social Activities ───────────────────────
  [
    QuickChatItem(name: 'Sosyal Aktiviteler',      imagePath: '${_base}social.png'),
    QuickChatItem(name: 'Dinlenmek istiyorum',      imagePath: '${_base}rest.png'),
    QuickChatItem(name: 'Merhaba',           imagePath: '${_base}hello.png'),
    QuickChatItem(name: 'Kafam karışık',            imagePath: '${_base}confused.png'),
    QuickChatItem(name: 'Çok karanlık',             imagePath: '${_base}dark.png'),
    QuickChatItem(name: 'Radyo dinlemek istiyorum', imagePath: '${_base}radio.png'),
    QuickChatItem(name: 'İyiyim',                   imagePath: '${_base}fine.png'),
  ],

  // ── Section 5: Medical Needs ────────────────────────────
  [
    QuickChatItem(name: 'Sağlık İhtiyaçları',      imagePath: '${_base}medical.png'),
    QuickChatItem(name: 'Temel bakım gerekiyor',    imagePath: '${_base}care.png'),
    QuickChatItem(name: 'Özür Dilerim',           imagePath: '${_base}apologize.png'),
    QuickChatItem(name: 'Gerginim',                 imagePath: '${_base}nervous.png'),
    QuickChatItem(name: 'Hava bunaltıcı',           imagePath: '${_base}stuffy.png'),
    QuickChatItem(name: 'Oyun oynamak istiyorum',   imagePath: '${_base}game.png'),
    QuickChatItem(name: 'Doktora ihtiyacım var',    imagePath: '${_base}doctor.png'),
  ],
];
