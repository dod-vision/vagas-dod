class ImageConverted{

  final String emissora;
  final List pessoas;
  final List objetos;
  final String urlImage;

  ImageConverted({this.emissora,this.pessoas,this.objetos,this.urlImage});

  final String url = 'https://tv.dodvision.com/';

  factory ImageConverted.fromJson(Map<String, dynamic> parsedJson){
    return ImageConverted(
        emissora: parsedJson['emissora'].toString(),
        pessoas: parsedJson['emissora']['pessoas'],
        objetos: parsedJson['emissora']['objects'],
        urlImage: parsedJson['emissora']['final_image'].toString()
    );
  }
}