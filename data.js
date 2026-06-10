// --- Social Icon SVGs mapping ---
const socialIcons = {
    instagram: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line></svg>`,
    linkedin: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path><rect x="2" y="9" width="4" height="12"></rect><circle cx="4" cy="4" r="2"></circle></svg>`,
    gmail: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>`
};

// --- Technical Cards Content ---
const technicalData = [
    {
        titleEn: "Computer Vision",
        titleTr: "Bilgisayarlı Görü",
        descEn: "Powered by MediaPipe Face Mesh algorithms to detect facial landmarks and track gaze direction. Calculates head pose in 3D space using the Perspective-n-Point (PnP) algorithm to eliminate tilt errors, and integrates a Linear Regression model to filter gaze jitter.",
        descTr: "MediaPipe Face Mesh algoritmalarıyla yüz işaret noktalarını tespit edip göz bakış yönünü takip eder. Kafa eğikliği sapmalarını önlemek için Perspective-n-Point (PnP) algoritmasıyla 3D kafa rotasyon tespiti yapar ve titremeleri (jitter) azaltıp pürüzsüz imleç hareketi sağlamak için Doğrusal Regresyon modeli kullanır."
    },
    {
        titleEn: "Generative AI",
        titleTr: "Üretken Yapay Zeka",
        descEn: "Integrates both local LLMs for offline use and maximum privacy, and online models (ChatGPT, Gemini, Claude) for high-speed performance. These models maximize efficiency by expanding minimal user gaze input into full, contextual sentences.",
        descTr: "Çevrimdışı kullanım ve maksimum veri gizliliği için yerel (local) LLM'lerin yanı sıra, yüksek hız ve performans sunan çevrimiçi model (ChatGPT, Gemini, Claude) seçeneklerini entegre eder. Bu modeller, girdiyi minimize edip çıktıyı maksimize ederek iletişim verimliliğini artırır."
    },
    {
        titleEn: "Social & Visual Interfaces",
        titleTr: "Sosyal ve Görsel Arayüzler",
        descEn: "Features a Social module connecting patients with remote peers and acquaintances, and a Visual module with images enabling quick, letter-free communication for illiterate users.",
        descTr: "Hastaların sadece yanlarındakilerle değil, uzaktaki akranları (peer) ve tanıdıklarıyla da iletişim kurmasını sağlayan bir Sosyal sekmesi ile okuma yazma bilmeyenlerin bile metin yazmakla uğraşmadan hızlıca iletişim kurabilmesi için görsellerden oluşan bir Görsel sekmesi içerir."
    }
];

// --- Achievements & Awards Content ---
const achievementsData = [
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6" /><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18" /><path d="M4 22h16" /><path d="M10 14.66V17c0 .55-.45 1-1 1H4v2h16v-2h-5c-.55 0-1-.45-1-1v-2.34" /><path d="M12 2a6 6 0 0 1 6 6v3.5c0 1.66-1.34 3-3 3H9a3 3 0 0 1-3-3V8a6 6 0 0 1 6-6z" /></svg>`,
        dateEn: "May 2026",
        dateTr: "Mayıs 2026",
        titleEn: "Regeneron ISEF 2026 - Fourth Place",
        titleTr: "Regeneron ISEF 2026 - Dünya Dördüncülüğü",
        issuerEn: "Issued by Microsoft",
        issuerTr: "Veren Kurum: Microsoft",
        descEn: "Selected as a finalist to compete in the world's largest pre-college science fair and won the fourth place in the Software category.",
        descTr: "Dünyanın en büyük üniversite öncesi bilim fuarında yarışarak Yazılım kategorisinde dünya dördüncülüğü derecesi elde etti."
    },
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7" /><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88" /></svg>`,
        dateEn: "May 2026",
        dateTr: "Mayıs 2026",
        titleEn: "Regeneron ISEF 2026 - AAAI Special Award",
        titleTr: "Regeneron ISEF 2026 - AAAI Özel Ödülü",
        issuerEn: "Issued by Association for the Advancement of Artificial Intelligence",
        issuerTr: "Veren Kurum: Yapay Zekayı Geliştirme Derneği (AAAI)",
        descEn: "Awarded the prestigious Special Award by the Association for the Advancement of Artificial Intelligence (AAAI) at Regeneron ISEF 2026.",
        descTr: "Regeneron ISEF 2026'da Yapay Zekayı Geliştirme Derneği (AAAI) tarafından prestijli Özel Ödül'e layık görüldü."
    },
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A5 5 0 0 0 8 8c0 1 .3 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5" /><line x1="9" y1="18" x2="15" y2="18" /><line x1="10" y1="22" x2="14" y2="22" /></svg>`,
        dateEn: "May 2026",
        dateTr: "Mayıs 2026",
        titleEn: "MEF 2026 - Special Innovation Award",
        titleTr: "MEF 2026 - Özel İnovasyon Ödülü",
        issuerEn: "Issued by MEF Educational Institutions",
        issuerTr: "Veren Kurum: MEF Eğitim Kurumları",
        descEn: "Awarded the Special Innovation Award in the Artificial Intelligence category at the MEF 2026 Research Projects Competition.",
        descTr: "MEF 2026 Araştırma Projeleri Yarışması'nda Yapay Zeka kategorisinde Özel İnovasyon Ödülü'ne layık görüldü."
    },
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2" /><line x1="8" y1="21" x2="16" y2="21" /><line x1="12" y1="17" x2="12" y2="21" /></svg>`,
        dateEn: "Sep 2025",
        dateTr: "Eylül 2025",
        titleEn: "Teknofest Turkey - Best Presentation Award",
        titleTr: "Teknofest Türkiye - En İyi Sunum Ödülü",
        issuerEn: "Issued by T3 Foundation",
        issuerTr: "Veren Kurum: T3 Vakfı",
        descEn: "Awarded the Best Presentation Award at the Teknofest finals for our outstanding communication and presentation skills in showcasing our AI-powered eye-tracking system.",
        descTr: "Teknofest finallerinde yapay zeka destekli göz takibi sistemimizi tanıtırken sergilediğimiz başarılı sunum ve etkili iletişim becerilerimizden ötürü En İyi Sunum Ödülü'ne layık görüldü."
    },
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6" /><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18" /><path d="M4 22h16" /><path d="M10 14.66V17c0 .55-.45 1-1 1H4v2h16v-2h-5c-.55 0-1-.45-1-1v-2.34" /><path d="M12 2a6 6 0 0 1 6 6v3.5c0 1.66-1.34 3-3 3H9a3 3 0 0 1-3-3V8a6 6 0 0 1 6-6z" /></svg>`,
        dateEn: "Sep 2025",
        dateTr: "Eylül 2025",
        titleEn: "Teknofest Turkey - 1st Place",
        titleTr: "Teknofest Türkiye - Türkiye Birinciliği",
        issuerEn: "Issued by T3 Foundation",
        issuerTr: "Veren Kurum: T3 Vakfı",
        descEn: "Won the 1st Place in the Barrier-Free Living Technologies category at Teknofest for developing our low-cost, AI-driven eye-tracking system that helps ALS patients communicate.",
        descTr: "ALS hastalarının iletişim kurmasını sağlayan düşük maliyetli ve yapay zeka destekli göz takibi sistemimizle Teknofest Engelsiz Yaşam Teknolojileri kategorisinde Türkiye Birinciliği elde etti."
    },
    {
        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6" /><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11" /></svg>`,
        dateEn: "May 2025",
        dateTr: "Mayıs 2025",
        titleEn: "TÜBİTAK 2204-A - 2nd Place",
        titleTr: "TÜBİTAK 2204-A - Türkiye İkinciliği",
        issuerEn: "Issued by The Scientific and Technological Research Council of Türkiye",
        issuerTr: "Veren Kurum: TÜBİTAK",
        descEn: "Ranked 2nd in Turkey in the Software category in the TÜBİTAK 2204-A Research Projects Competition.",
        descTr: "TÜBİTAK 2204-A Lise Öğrencileri Araştırma Projeleri Yarışması'nda Yazılım kategorisinde Türkiye 2.'si oldu."
    }
];

// --- Team Members Content ---
const teamData = [
    {
        name: "Eren Aygün",
        img: "https://media.licdn.com/dms/image/v2/D5603AQERY93smAyMyw/profile-displayphoto-crop_800_800/B56Z4832zHJkAI-/0/1779137736440?e=1782950400&v=beta&t=Nzc4Xp_wFTAr4fuui7cLssn_U2eMd2hW3k72LIH1aZU",
        roleEn: "Team Captain & Coordinator",
        roleTr: "Takım Kaptanı ve Koordinatörü",
        descEn: "Oversees the overall project direction, coordinates team workflow, manages timelines, and handles external communication and competition logistics.",
        descTr: "Projenin genel yönünü belirler, ekip içi iş akışını koordine eder, zaman planlamasını yönetir ve dış iletişim ile yarışma süreçlerini yürütür.",
        socials: [
            { type: "instagram", url: "https://instagram.com/eerenaygun" },
            { type: "linkedin", url: "https://linkedin.com/in/eerenaygun" },
            { type: "gmail", url: "mailto:erenaygun72@gmail.com" }
        ]
    },
    {
        name: "Sinan Güneş",
        img: "https://media.licdn.com/dms/image/v2/D4D03AQF1LjChv8NwLA/profile-displayphoto-crop_800_800/B4DZ1S3SeBGsAI-/0/1775211730745?e=1782950400&v=beta&t=oVrBhFk-8AuaJJIvF0vKL-nzKKupUb_3X6SZpw5a-Ho",
        roleEn: "Lead Developer & AI Architect",
        roleTr: "Yazılımcı ve Yapay Zeka Mimarı",
        descEn: "Designs and implements the core eye-tracking algorithms, integrates computer vision and AI models, and ensures system performance and accuracy.",
        descTr: "Göz takip algoritmalarını tasarlar ve geliştirir, bilgisayarlı görü ve yapay zeka modellerini entegre eder, sistemin performans ve doğruluğunu sağlar.",
        socials: [
            { type: "instagram", url: "https://instagram.com/wsnn267_" },
            { type: "linkedin", url: "https://linkedin.com/in/gunessinan" },
            { type: "gmail", url: "mailto:gunessinan267@gmail.com" }
        ]
    },
    {
        name: "Eyüp Bilir",
        img: "https://media.licdn.com/dms/image/v2/D4D03AQGdjt9v0zPpvA/profile-displayphoto-crop_800_800/B4DZ6DeZlYKIAI-/0/1780322245927?e=1782950400&v=beta&t=O0QlsYdBpTR-B8Xxz16Ykz3nUZDPmpgW2N_8p2TCP3E",
        roleEn: "Product Designer",
        roleTr: "Ürün Tasarımcısı",
        descEn: "Leads academic documentation and research reporting, contributes to product design decisions, and supports user-centered UI/UX development.",
        descTr: "Akademik dokümantasyon ve araştırma raporlamasını yürütür, ürün tasarım kararlarına katkı sağlar ve kullanıcı odaklı UI/UX geliştirmesini destekler.",
        socials: [
            { type: "instagram", url: "https://instagram.com/eyup_blr_" },
            { type: "linkedin", url: "https://linkedin.com/in/eeyup-bilir" },
            { type: "gmail", url: "mailto:eyupbilir86@gmail.com" }
        ]
    }
];

// --- Advisor Teacher Content ---
const advisorData = {
    name: "Emre Arslan",
    img: "Pictures/advisor.png",
    roleEn: "Advisor Teacher",
    roleTr: "Danışman Öğretmen",
    socials: [
        { type: "gmail", url: "mailto:eemre.arslan@gmail.com" }
    ]
};
