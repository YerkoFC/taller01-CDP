import 'dart:io';
import 'dart:convert';
import 'dart:math';

// Redondea un numero double con dos decimales
double roundDouble(double value, int decimals){ 
   double mod = pow(10.0, decimals); 
   return ((value * mod).round().toDouble() / mod); 
}

// Retorna el promedio de los  puntajes redondeados con 2 decimales
double avgScore(List<String> scores){
  var sum = 0, cont = 0;
  scores.forEach((score){
    sum += int.parse(score);
    cont++;
  });
  final double result = sum / cont;
  return roundDouble(result, 2); 
}

// Promedia los puntajes y los escribe en un archivo de salida
// junto con su respectivo rut
void splitLinea(String linea, File fileOut){
  var lineSplited = linea.split(';');
  var avgs = lineSplited.sublist(1);
  var rut = lineSplited[0];
  double avg = avgScore(avgs);
  fileOut.writeAsStringSync('$rut;$avg\n', mode: FileMode.append);
} 

main(List<String> args) {
  try {
    if(args.isEmpty){
      throw 'Debe ingresar una ruta como argumento.\n';
    }
    String fileOutName = 'archivoSalida.csv';
    File fileIn = new File(args[0]);
    File fileOut = new File(fileOutName);
    fileIn.openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())  
      .listen((String linea) {
        splitLinea(linea, fileOut);
        },
        onDone: () { print('El archivo \'${args[0]}\' ya esta cerrado.'); },
        onError: (e) { print(e.toString());}
      );
  } catch (e) {
    print(e);
  } 
}