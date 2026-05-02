// --- MERKEZI VERI BANKASI ---
double sanalBakiye = 300.0;
int aylikKahveSayisi = 0; // %10 indirim yildizlari icin
int mevcutDamga = 0; // 6 damga = 1 hediye kahve icin
int hediyeKahveSayisi = 0;
String secilenMetot = ""; // QR ile secilen odeme yontemi
String musteriAdi = "Ahmet Yilmaz";
List<Map<String, String>> hareketler = [];

// --- AKILLI KURALLAR ---
bool isYildizDolu() => aylikKahveSayisi >= 6; // 6 kahve baraji

double getSadakatIndirimi() => isYildizDolu() ? 0.10 : 0.0; // %10 indirim
