import 'package:desafio_dod/classes/image_class.dart';
import 'package:desafio_dod/tabs/camera_tab.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  final Map<String, dynamic> imageResponse;

  HomeTab(this.imageResponse);

  @override
  Widget build(BuildContext context) {

    String url = 'https://tv.dodvision.com/';

    ImageConverted convertedImage = ImageConverted.fromJson(imageResponse);

    return Scaffold(
      appBar: AppBar(
        title: Text("Desafio Dod"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Stack(
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: url + convertedImage.urlImage,
                      ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                SizedBox(width: 15,),
                Text("Objetos: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(convertedImage.objetos.toString().replaceAll('[', '').replaceAll(']', ''))
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                SizedBox(width: 15,),
                Text("Pessoas: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(convertedImage.pessoas.toString().replaceAll('[', '').replaceAll(']', '') == '' ? 'Não há pessoas'
                    : convertedImage.pessoas.toString().replaceAll('[', '').replaceAll(']', '') == ''
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 40,
                width: 150,
                child: RaisedButton(
                  child: Text("Tirar foto", style: TextStyle(fontSize: 17)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraTab()));
                  },
                ),
              )
            )
          ],
        ),
      )
    );
  }
}
