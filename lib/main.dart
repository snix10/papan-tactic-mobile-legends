import 'package:flutter/material.dart';

void main() {
  runApp(TacticBoardApp());
}

class TacticBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TacticBoardScreen(),
    );
  }
}

class TacticBoardScreen extends StatefulWidget {
  @override
  _TacticBoardScreenState createState() => _TacticBoardScreenState();
}

class _TacticBoardScreenState extends State<TacticBoardScreen> {
  List<Player> players = [];

  List<String> teamPlayers = [
    'Player 1',
    'Player 2',
    'Player 3'
  ]; // Daftar pemain tim Anda
  List<String> opponentTeamPlayers = [
    'Opponent Player 1',
    'Opponent Player 2',
    'Opponent Player 3'
  ]; // Daftar pemain tim lawan

  List<String> playerImages = [
    'assets/akai.jpeg',
    'assets/digie.jpeg',
    'assets/jhonson.jpeg'
  ]; // Daftar path gambar pemain
  List<String> opponentTeamPlayerImages = [
    'assets/angela.jpeg',
    'assets/chou.jpeg',
    'assets/mage.jpeg'
  ]; // Daftar path gambar pemain lawan

  bool isMenuVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Papan Taktik'),
      ),
      body: Column(
        children: [
          // Daftar Pemain

          // Papan Taktik
          Expanded(
            child: Stack(
              children: [
                // Gambar lapangan
                Image.asset(
                  'assets/map_mobile_legends.png', // Ganti dengan path gambar lapangan Anda
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Pemain
                ...players.map((player) {
                  return Positioned(
                    left: player.position.dx,
                    top: player.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          player.position += details.delta;
                        });
                      },
                      child: PlayerWidget(player: player),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleMenuVisibility();
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      endDrawer: isMenuVisible
          ? _navbarRed(teamPlayers, playerImages, "red")
          : null,
    );
  }

  Widget _buildEndDrawer(
      List<String> playerList, List<String> playerImages, String team) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Jumlah kolom dalam grid
                  crossAxisSpacing: 8.0, // Spasi antar kolom
                  mainAxisSpacing: 8.0, // Spasi antar baris
                ),
                itemCount: playerImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        players.add(Player(
                          position: Offset(150, 150),
                          name:
                              '', // Anda bisa mengosongkan nama pemain jika tidak diperlukan
                          image: playerImages[index],
                          team: team, // Atur tim pemain
                        ));
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(
                        playerImages[index],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navbarRed(
      List<String> playerList, List<String> playerImages, String team) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Jumlah kolom dalam grid
                  crossAxisSpacing: 8.0, // Spasi antar kolom
                  mainAxisSpacing: 8.0, // Spasi antar baris
                ),
                itemCount: playerImages.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        players.add(Player(
                          position: Offset(150, 150),
                          name:
                              '', // Anda bisa mengosongkan nama pemain jika tidak diperlukan
                          image: playerImages[index],
                          team: team, // Atur tim pemain
                        ));
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(
                        playerImages[index],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMenuVisibility() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  

  void _showSelectPlayerDialog(
      List<String> playerList, List<String> playerImages, String team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Pemain'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playerList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(playerList[index]),
                  leading: Image.asset(
                    playerImages[index],
                    width: 40,
                    height: 40,
                  ),
                  onTap: () {
                    setState(() {
                      players.add(Player(
                        position: Offset(150, 150),
                        name: playerList[index],
                        image: playerImages[index],
                        team: team, // Atur tim pemain
                      ));
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class Player {
  Offset position;
  String name;
  String image;
  String team; // Tambahkan atribut team

  Player(
      {required this.position,
      required this.name,
      required this.image,
      required this.team});
}

class PlayerWidget extends StatelessWidget {
  final Player player;

  const PlayerWidget({required this.player});

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent; // Default border color

    // Menentukan warna border berdasarkan tim
    if (player.team == "red") {
      borderColor = Colors.red;
    } else if (player.team == "blue") {
      borderColor = Colors.blue;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor, // Warna border sesuai tim
          width: 3, // Lebar border 2 pixels
        ),
        image: DecorationImage(
          image: AssetImage(player.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Text(player.name),
    );
  }
}
