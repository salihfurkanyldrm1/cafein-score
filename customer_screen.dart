import 'package:flutter/material.dart';
import 'global_data.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  bool _qrAcik = false;

  void _profilAyarlari() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 15),
            Text(
              musteriAdi,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("ahmet@mail.com", style: TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Tum Islem Gecmisi"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Uygulama Ayarlari"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Cikis Yap",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barista Loop"),
        actions: [
          IconButton(
            onPressed: _profilAyarlari,
            icon: const Icon(Icons.account_circle, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCuzdanKarti(),
            const SizedBox(height: 30),
            _buildSectionTitle("KAFEIN YILDIZLARI (Aylik %10 Indirim)"),
            _buildYildizlar(),
            const SizedBox(height: 30),
            _buildSectionTitle("HEDIYE KAHVE DAMGALARI (6/1)"),
            _buildDamgalar(),
            const SizedBox(height: 30),
            _qrAcik ? _buildQRDisplay() : _buildQRGenerator(),
            const SizedBox(height: 40),
            _buildSectionTitle("SON ISLEMLER"),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCuzdanKarti() => Container(
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.brown[800]!, Colors.brown[600]!],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.brown.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        const Text(
          "Guncel Bakiye",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          "TL ${sanalBakiye.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() => sanalBakiye += 100),
              icon: const Icon(Icons.add),
              label: const Text("100 TL YUKLE"), // Bakiye yükleme aktif!
            ),
          ],
        ),
        if (isYildizDolu())
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "YILDIZLAR DOLDU! %10 INDIRIMINIZ AKTIF!",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    ),
  );

  Widget _buildYildizlar() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      6,
      (i) => Icon(
        Icons.star,
        size: 40,
        color: i < aylikKahveSayisi ? Colors.amber : Colors.grey[300],
      ),
    ),
  );

  Widget _buildDamgalar() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      6,
      (i) => Icon(
        Icons.local_cafe,
        size: 30,
        color: i < mevcutDamga ? Colors.brown : Colors.grey[300],
      ),
    ),
  );

  Widget _buildQRGenerator() => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 60),
      backgroundColor: Colors.brown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    onPressed: () {
      showModalBottomSheet(
        context: context,
        builder: (c) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("Uygulama Bakiyesi ile Ode"),
              onTap: () {
                setState(() {
                  secilenMetot = "Uygulama Bakiyesi";
                  _qrAcik = true;
                });
                Navigator.pop(c);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text("Nakit veya Kart ile Ode"),
              onTap: () {
                setState(() {
                  secilenMetot = "Nakit";
                  _qrAcik = true;
                });
                Navigator.pop(c);
              },
            ),
          ],
        ),
      );
    },
    icon: const Icon(Icons.qr_code, color: Colors.white),
    label: const Text(
      "ODEME YAP / QR OLUSTUR",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildQRDisplay() => Column(
    children: [
      const Icon(Icons.qr_code_2, size: 150, color: Colors.black87),
      Text(
        "Odeme Yontemi: $secilenMetot",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextButton(
        onPressed: () => setState(() => _qrAcik = false),
        child: const Text("QR Kodunu Kapat"),
      ),
    ],
  );

  Widget _buildSectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ),
  );

  Widget _buildHistoryList() => ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: hareketler.length,
    itemBuilder: (c, i) {
      var item = hareketler[hareketler.length - 1 - i];
      return Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.brown,
            child: Icon(Icons.shopping_basket, color: Colors.white, size: 20),
          ),
          title: Text(
            item['islem']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item['detay']!),
          trailing: Text(
            item['tutar']!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}
