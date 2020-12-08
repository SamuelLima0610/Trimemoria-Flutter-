import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/back/back.dart';
import 'package:trimemoria/models/DataModel.dart';
import 'package:path/path.dart';


class ThemesImages extends StatefulWidget {
  @override
  _ThemesImagesState createState() => _ThemesImagesState();
}

class _ThemesImagesState extends State<ThemesImages> {

  File _image;
  //final picker = ImagePicker();
  final _stateForm = GlobalKey<FormState>();
  final _groupController = TextEditingController();
  String value;
  String _url, _path;
  bool first = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(5.0),
        child: ScopedModelDescendant<DataModel>(
            builder: (context,child,model){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Form(
                    key: _stateForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _groupController,
                          decoration: InputDecoration(
                              labelText: 'Group',
                              labelStyle: TextStyle(color: Colors.blueAccent)
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty) return "O campo deve ser preenchido";
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FutureBuilder(
                            future: Back.getData('https://rest-api-trimemoria.herokuapp.com/theme'),
                            builder: (context, snapshot){
                              if(snapshot.hasData) {
                                if(!model.toEdit() && first){
                                  first = false;
                                  value = snapshot.data['data'][0]['name'];
                                }
                                return DropdownButton<String>(
                                    value: value,
                                    elevation: 1,
                                    items:
                                    snapshot.data['data'].map<
                                        DropdownMenuItem<String>>((v) {
                                      return DropdownMenuItem<String>(
                                          value: v['name'],
                                          child: Text(v['name'])
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        value = newValue;
                                      });
                                    }
                                );
                              }
                              else
                                return Container();
                            }
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text( !model.toEdit() ? 'Adicionar Imagem': 'Alterar Imagem'),
                            onTap: () {
                              _imgFromGallery();
                            }),
                        _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  String path = '';
                                  String url = '';
                                  if(_stateForm.currentState.validate() && value != '' && _image != null){
                                    String filename = basename(_image.path);
                                    path = "$value/$filename";
                                    if(model.toEdit())
                                      await Back.deleteImageStorage(_path);
                                    url = await Back.sendImageStorage(path, _image);
                                  }
                                  else if(_stateForm.currentState.validate() && value != ''){
                                    path = _path;
                                    url = _url;
                                  }
                                  if(path != '' && url != '' && _image != null){
                                    Map<String,dynamic> data ={
                                      "group": _groupController.text,
                                      "theme": value,
                                      "url": url,
                                      "path": path
                                    };
                                    String answer = await model.insert(data: data);
                                    final snackBar = SnackBar(
                                      content: Text(
                                          answer
                                      ),
                                      duration: Duration(seconds: 5),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                },
                                color: Colors.blueAccent,
                                child: Text(
                                    !model.toEdit() ? 'Salvar' : "Editar",
                                    style: TextStyle(color: Colors.white,fontSize: 22.0)
                                ),
                              ),
                              RaisedButton(
                                onPressed: () async {
                                  if(!model.toEdit()){
                                    setState(() {
                                      _groupController.text = '';
                                      first = true;
                                      _image = null;
                                    });
                                    model.refresh();
                                  }else{
                                    if(_stateForm.currentState.validate()) {
                                      String answer = await model.destroy();
                                      await Back.deleteImageStorage(_path);
                                      final snackBar = SnackBar(
                                        content: Text(
                                            answer
                                        ),
                                        duration: Duration(seconds: 5),
                                      );
                                      Scaffold.of(context).showSnackBar(
                                          snackBar);
                                    }
                                  }
                                },
                                color: Colors.blueAccent,
                                child: Text(
                                    model.toEdit() ? "Excluir" : 'Limpar',
                                    style: TextStyle(color: Colors.white,fontSize: 22.0)
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: model.getList(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        else
                          return SafeArea(
                              child: makeTable(
                                  snapshot.data.length,
                                  snapshot.data,
                                  model
                              )
                          );
                      }
                  )
                ],
              );
            }
        )
    );
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  Widget makeTable(int size, List themes, DataModel model){
    var dts = DTS(themes, model, (index) async{
          await model.change(id: themes[index]['id']);
          setState(() {
            _groupController.text = model.information['data']['group'];
            value = model.information['data']['theme'];
            _url = model.information['data']['url'];
            _path = model.information['data']['path'];
          });
        });
    return PaginatedDataTable(
      header: Text("Theme's Image"),
      columns: const <DataColumn>[
        DataColumn(
            label: Text("Id",style: TextStyle(fontStyle: FontStyle.italic),)
        ),
        DataColumn(
            label: Text(
              "Tema",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
        ),
        DataColumn(
            label: Text(
              "Grupo",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
        ),
        DataColumn(
            label: Text(
              "Caminho",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
        ),
      ],
      source: dts,
      rowsPerPage: 5,
    );
  }

}

class DTS extends DataTableSource{

  List images;
  DataModel model;
  Function update;

  DTS(this.images,this.model,this.update);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
        onSelectChanged: (v) async{
          update(index);
        },
        index: index,
        cells: [
          DataCell(Text('${images[index]['id']}')),
          DataCell(Text('${images[index]['theme']}')),
          DataCell(Text('${images[index]['group']}')),
          DataCell(Text('${images[index]['path']}'))
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => images.length;

  @override
  int get selectedRowCount => 0;

}