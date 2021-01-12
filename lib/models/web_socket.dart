import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TagSocket extends Model{

  final IO.Socket socket;
  Map<String,dynamic> message;

  TagSocket(this.socket){
    socket.on('tag', (data) {
      message = data;
      print(message);
      notifyListeners();
    });
  }

}