import 'package:flutter/material.dart';
import 'global_data.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  double kBirimFiyat = 100.0;
  double tBirimFiyat = 150.0;
  int kAdet = 1;
  int tAdet = 0;
  int hKullan = 0;
  bool qrOkundu = false;

  void islemOnayla() {
    if (secilenMetot == "") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("QR henuz okutulmadi!")));
      return;
    }

    // 1. Hediye Kahve Onceligi (Once bedava olan duser)
    int kalanKAfterHediye = (kAdet - hKullan) < 0 ? 0 : (kAdet - hKullan);

    // 2. Combo Mantigi (Kalan kahveler tatliyla eslesirse 50 TL olur)
    int comboAdedi = (kalanKAfterHediye < tAdet) ? kalanKAfterHediye : tAdet;
    int normalKAdedi = kalanKAfterHediye - comboAdedi;

    double araToplam =
        (tAdet * tBirimFiyat) +
        (comboAdedi * 50.0) +
        (normalKAdedi * kBirimFiyat);
    double indirimTL = araToplam * getSadakatIndirimi();
    double net = araToplam - indirimTL;

    setState(() {
      if (secilenMetot == "Uygulama Bakiyesi") sanalBakiye -= net;

      String detay =
          "${tAdet}x Tatli, ${hKullan}x Hediye, ${comboAdedi}x Combo, ${normalKAdedi}x Normal";
      hareketler.add({
        'islem': 'Satis Onaylandi',
        'detay': detay,
        'tutar': "-TL ${net.toStringAsFixed(2)}",
        'tarih': '04.02.2026',
      });

      hediyeKahveSayisi -= hKullan;
      aylikKahveSayisi += kalanKAfterHediye;
      mevcutDamga += kalanKAfterHediye;
      while (mevcutDamga >= 6) {
        hediyeKahveSayisi++;
        mevcutDamga -= 6;
      }

      qrOkundu = false;
      kAdet = 1;
      tAdet = 0;
      hKullan = 0;
      secilenMetot = "";
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barista POS")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Musteri Hediye Bakiyesi"),
                subtitle: Text("Birikmis Bedava Kahve: $hediyeKahveSayisi"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => setState(() => qrOkundu = true),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("QR TARA"),
            ),
            if (qrOkundu) ...[
              const Divider(height: 40),
              _fiyatInput(
                "Kahve Fiyati",
                (v) => setState(() => kBirimFiyat = double.tryParse(v) ?? 100),
              ),
              _fiyatInput(
                "Tatli Fiyati",
                (v) => setState(() => tBirimFiyat = double.tryParse(v) ?? 150),
              ),
              _sayac("Toplam Kahve", kAdet, (v) => setState(() => kAdet = v)),
              _sayac("Toplam Tatli", tAdet, (v) => setState(() => tAdet = v)),
              if (hediyeKahveSayisi > 0)
                _sayac(
                  "Hediye Kullan",
                  hKullan,
                  (v) => setState(() {
                    if (v <= hediyeKahveSayisi && v <= kAdet) hKullan = v;
                  }),
                  color: Colors.orange,
                ),
              const SizedBox(height: 20),
              _ozetTablo(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: islemOnayla,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  "ONAYLA",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fiyatInput(String l, Function(String) o) => TextField(
    decoration: InputDecoration(labelText: l),
    keyboardType: TextInputType.number,
    onChanged: o,
  );

  Widget _sayac(
    String l,
    int v,
    Function(int) o, {
    Color color = Colors.black,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          IconButton(
            onPressed: () => o(v > 0 ? v - 1 : 0),
            icon: const Icon(Icons.remove),
          ),
          Text("$v"),
          IconButton(onPressed: () => o(v + 1), icon: const Icon(Icons.add)),
        ],
      ),
    ],
  );

  Widget _ozetTablo() {
    int kalan = (kAdet - hKullan) < 0 ? 0 : (kAdet - hKullan);
    int combo = (kalan < tAdet) ? kalan : tAdet;
    int norm = kalan - combo;
    double ara = (tAdet * tBirimFiyat) + (combo * 50.0) + (norm * kBirimFiyat);
    double ind = ara * getSadakatIndirimi();
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _row("${tAdet}x Tatli", "TL ${(tAdet * tBirimFiyat)}"),
          if (hKullan > 0)
            _row("${hKullan}x Hediye Kahve", "TL 0.00", color: Colors.orange),
          if (combo > 0)
            _row(
              "${combo}x Combo Kahve",
              "TL ${(combo * 50.0)}",
              color: Colors.blue,
            ),
          _row("${norm}x Normal Kahve", "TL ${(norm * kBirimFiyat)}"),
          const Divider(),
          _row("ARA TOPLAM", "TL ${ara.toStringAsFixed(2)}", bold: true),
          _row(
            "Yildiz Indirimi",
            "-TL ${ind.toStringAsFixed(2)}",
            color: Colors.red,
          ),
          _row(
            "NET",
            "TL ${(ara - ind).toStringAsFixed(2)}",
            bold: true,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v, {bool bold = false, Color? color}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        v,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}
