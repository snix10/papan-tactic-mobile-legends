import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(TacticBoardApp());
}

class TacticBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: TacticBoardScreen(),
    );
  }
}

class TacticBoardScreen extends StatefulWidget {
  @override
  _TacticBoardScreenState createState() => _TacticBoardScreenState();
}

class _TacticBoardScreenState extends State<TacticBoardScreen> {
  List<Player> players = []; // Daftar pemain yang sedang ditampilkan
  List<String> playerImages = [
    'assets/hayabusa.png',
    'assets/gusion.png',
    'assets/lancelot.png',
    'assets/helcurt.png',
    'assets/zilong.png',
    'assets/chou.png',
    'assets/leomord.png',
    'assets/martis.png',
    'assets/sun.png',
    'assets/kadita.png',
    'assets/lunox.png',
    'assets/vale.png',
    'assets/valir.png',
    'assets/nana.png',
    'assets/akai.png',
    'assets/gatot_kaca.png',
    'assets/jungler.png',
    'assets/midlane.png',
    'assets/roamer.png',
    'assets/explane.png',
    'assets/goldlane.png',
    'assets/biru.png',
    'assets/merah.png',
    
    // Tambahkan gambar pemain lainnya sesuai kebutuhan
  ];

  bool isDrawing = false; // Status menggambar garis aktif/nonaktif
  List<List<Offset>> lines = []; // Daftar garis yang telah digambar
  List<Color> linesColors = []; // Warna untuk setiap garis yang digambar
  List<Offset> currentLine = []; // Garis yang sedang digambar saat ini
  Color selectedColor = Colors.black; // Warna garis default
  Color selectedBorderColor = Colors.blue; // Warna tepi pemain default (biru)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(100), // Membuat sudut bawah melengkung
          ),
        ),
        elevation: 0, // Menghilangkan bayangan di bawah app bar
        title: Text('Tactic Board'), // Judul app bar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.face), // Icon untuk membuka drawer
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Fungsi untuk membuka drawer
              },
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.red], // Gradien dari biru ke merah
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDrawing = !isDrawing; // Mengubah status menggambar
                if (isDrawing) {
                  currentLine =
                      []; // Mengosongkan garis saat menggambar dimulai
                }
              });
            },
            icon: Icon(
              isDrawing ? Icons.border_color : Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                lines.clear(); // Menghapus semua garis yang telah digambar
                linesColors.clear(); // Menghapus warna dari semua garis
              });
            },
            icon: Icon(Icons.delete), // Icon untuk menghapus garis
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                        "Choose Line Color"), // Judul dialog pemilih warna garis
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor =
                                color; // Memperbarui warna garis yang dipilih
                          });
                        },
                        showLabel: true, // Menampilkan label warna
                        pickerAreaHeightPercent:
                            0.8, // Tinggi area pemilih warna
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Tombol OK untuk menutup dialog
                        },
                        child: Text('OK'), // Teks pada tombol OK
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.color_lens), // Icon untuk membuka pemilih warna
          ),
          IconButton(
            onPressed: () {
              setState(() {
                players.clear(); // Mengosongkan daftar pemain
              });
            },
            icon: Icon(Icons.refresh), // Icon untuk mereset papan
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanDown: (_) {
              if (isDrawing) {
                currentLine = []; // Mengosongkan garis saat mulai menggambar
              }
            },
            onPanUpdate: (details) {
              if (isDrawing) {
                setState(() {
                  currentLine.add(details
                      .localPosition); // Menambahkan titik saat menggambar
                });
              }
            },
            onPanEnd: (_) {
              if (isDrawing) {
                setState(() {
                  lines.add(List.from(
                      currentLine)); // Menambahkan garis ke daftar garis yang telah digambar
                  linesColors.add(
                      selectedColor); // Menambahkan warna garis ke daftar warna
                  currentLine
                      .clear(); // Mengosongkan garis saat selesai menggambar
                });
              }
            },
            child: Image.asset(
              'assets/map_mobile_legends.png', // Gambar peta latar belakang
              fit: BoxFit.cover, // Menyesuaikan gambar dengan layar
              width: double.infinity, // Lebar gambar mengisi layar
              height: double.infinity, // Tinggi gambar mengisi layar
            ),
          ),
          ...lines.asMap().entries.map((entry) {
            int index = entry.key;
            List<Offset> line = entry.value;
            return CustomPaint(
              key: Key('line_$index'), // Key unik untuk setiap garis
              painter: LinePainter(
                  points: line,
                  lineColor: linesColors[
                      index]), // Menggambar garis dengan warna yang sesuai
            );
          }).toList(),
          CustomPaint(
            key: Key('current_line'), // Key untuk garis yang sedang digambar
            painter: LinePainter(
                points: currentLine,
                lineColor:
                    selectedColor), // Menggambar garis saat ini dengan warna yang dipilih
          ),
          ...players.asMap().entries.map((entry) {
            int index = entry.key;
            Player player = entry.value;
            return Positioned(
              left: player.position.dx, // Posisi pemain horizontal
              top: player.position.dy, // Posisi pemain vertikal
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    players[index].position += details
                        .delta; // Menggerakkan pemain sesuai perubahan posisi
                  });
                },
                child: PlayerWidget(
                  player: player,
                  borderColor: player.team == "blue"
                      ? Colors.blue
                      : Colors.red, // Warna tepi pemain sesuai tim
                ),
              ),
            );
          }).toList(),
        ],
      ),
      drawer: _buildDrawer(), // Membangun drawer untuk memilih pemain
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.red], // Gradien dari biru ke merah
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Choose Hero', // Judul drawer untuk memilih pemain
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedBorderColor = Colors.blue; // Memilih tim biru
                      });
                    },
                    child: Text(
                      'Blue',
                      style: TextStyle(
                        color: Colors.black, // Warna teks hitam
                      ),
                    ), // Teks untuk memilih tim biru
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue), // Warna latar belakang tombol
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedBorderColor = Colors.red; // Memilih tim merah
                      });
                    },
                    child: Text(
                      'Red',
                      style: TextStyle(
                        color: Colors.black, // Warna teks hitam
                      ),
                    ), // Teks untuk memilih tim merah
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.red), // Warna latar belakang tombol
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Jumlah pemain per baris dalam grid
                  crossAxisSpacing: 8.0, // Jarak antar kolom dalam grid
                  mainAxisSpacing: 8.0, // Jarak antar baris dalam grid
                ),
                itemCount: playerImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        players.add(
                          Player(
                            position: Offset(150, 150), // Posisi default pemain
                            name: '', // Nama pemain kosong
                            image: playerImages[
                                index], // Gambar pemain yang dipilih
                            team: selectedBorderColor == Colors.blue
                                ? "blue"
                                : "red", // Tim pemain sesuai warna tepi yang dipilih
                          ),
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Player added to the board!',
                            style: TextStyle(
                              color: Colors.white, // Mengubah warna teks
                              fontSize: 16.0, // Ukuran font teks
                            ),
                          ),
                          duration:
                              Duration(seconds: 2), // Durasi tampilan pesan
                         
                          
                        ),
                      );

                      Navigator.of(context)
                          .pop(); // Menutup drawer setelah pemain ditambahkan
                    },
                    child: Container(
                      width: 50, // Lebar kontainer pemain dalam grid
                      height: 50, // Tinggi kontainer pemain dalam grid
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              selectedBorderColor, // Warna tepi sesuai tim yang dipilih
                          width: 2, // Lebar tepi pemain
                        ),
                        borderRadius: BorderRadius.circular(
                            50), // Mengubah kontainer menjadi lingkaran
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50), // Memotong gambar pemain menjadi lingkaran
                        child: Image.asset(
                          playerImages[
                              index], // Menampilkan gambar pemain yang dipilih
                          fit: BoxFit.cover, // Mengisi kontainer dengan gambar
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  Offset position; // Posisi pemain pada papan
  String name; // Nama pemain (tidak digunakan dalam kode ini)
  String image; // Gambar pemain
  String team; // Tim pemain (biru atau merah)

  Player({
    required this.position,
    required this.name,
    required this.image,
    required this.team,
  });
}

class PlayerWidget extends StatelessWidget {
  final Player player; // Data pemain
  final Color borderColor; // Warna tepi pemain

  const PlayerWidget({
    Key? key,
    required this.player,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1), // Padding di sekitar gambar pemain
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Bentuk kontainer lingkaran
        border: Border.all(
            color: borderColor, width: 2), // Tepi dengan warna yang dipilih
      ),
      child: Image.asset(
        player.image, // Menampilkan gambar pemain
        width: 40, // Lebar gambar pemain
        height: 40, // Tinggi gambar pemain
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points; // Titik-titik untuk digambar
  final Color lineColor; // Warna garis

  LinePainter({required this.points, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return; // Jika tidak ada titik, tidak ada yang digambar
    Paint paint = Paint()
      ..color = lineColor // Mengatur warna cat
      ..strokeCap = StrokeCap.round // Bentuk ujung garis
      ..strokeWidth = 4.0; // Lebar garis

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1],
            paint); // Menggambar garis antara dua titik berturut-turut
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Menggambar ulang garis saat terjadi perubahan
  }
}
