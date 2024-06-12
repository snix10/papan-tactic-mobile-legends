import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zoomable Image with Player Object'),
        ),
        body: Center(
          child: ZoomableImageWithPlayerObject(
            largeImageAsset: 'assets/map_mobile_legends.png', // Gambar peta besar
            playerImageAsset: 'assets/Minimap.png', // Gambar objek pemain
          ),
        ),
      ),
    );
  }
}

class ZoomableImageWithPlayerObject extends StatefulWidget {
  final String largeImageAsset;
  final String playerImageAsset;

  ZoomableImageWithPlayerObject({
    required this.largeImageAsset,
    required this.playerImageAsset,
  });

  @override
  _ZoomableImageWithPlayerObjectState createState() =>
      _ZoomableImageWithPlayerObjectState();
}

class _ZoomableImageWithPlayerObjectState
    extends State<ZoomableImageWithPlayerObject> {
  double _scale = 1.0;
  Offset _playerPosition = Offset(100, 100); // posisi awal pemain

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Update posisi pemain dengan memperhitungkan perubahan skala
          _playerPosition += details.delta / _scale;
        });
      },
      child: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(double.infinity),
        minScale: 0.5,
        maxScale: 5.0,
        onInteractionUpdate: (details) {
          setState(() {
            _scale = details.scale;
          });
        },
        child: Stack(
          children: [
            Image.asset(
              widget.largeImageAsset,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
            Positioned(
              left: _playerPosition.dx,
              top: _playerPosition.dy,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _playerPosition += details.delta / _scale;
                    });
                  },
                  child: Image.asset(
                    widget.playerImageAsset,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
