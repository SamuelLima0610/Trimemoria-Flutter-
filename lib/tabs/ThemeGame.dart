import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/models/DataModel.dart';

class ThemeGame extends StatefulWidget {

  @override
  _ThemeGameState createState() => _ThemeGameState();
}

class _ThemeGameState extends State<ThemeGame> {

  final _nameController = TextEditingController();
  final _qntController = TextEditingController();
  final _stateForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(5.0),
        child: ScopedModelDescendant<DataModel>(
            builder: (context, child, model){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Form(
                    key: _stateForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: 'Nome',
                              labelStyle: TextStyle(
                                  color: Colors.orange,
                              )
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty) return "O campo deve ser preenchido";
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _qntController,
                          decoration: InputDecoration(
                              hintText: 'Quantidade',
                              labelStyle: TextStyle(color: Colors.blueAccent)
                          ),
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty) return "O campo deve ser preenchido";
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFFF8306),
                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if(_stateForm.currentState.validate()){
                                      Map<String,dynamic> data ={
                                        "name": _nameController.text,
                                        "qntd": _qntController.text
                                      };
                                      String answer = await model.insert(data: data);
                                      final snackBar = SnackBar(
                                        content: Text(
                                            answer
                                        ),
                                        duration: Duration(seconds: 5),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text(
                                      !model.toEdit() ? 'Salvar' : "Editar",
                                      style: TextStyle(color: Colors.white,fontSize: 22.0)
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8306),
                                  borderRadius: BorderRadius.all(Radius.circular(16))
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if(!model.toEdit()){
                                      setState(() {
                                        _nameController.text = '';
                                        _qntController.text = '';
                                      });
                                      model.refresh();
                                    }else{
                                      if(_stateForm.currentState.validate()) {
                                        String answer = await model.destroy();
                                        final snackBar = SnackBar(
                                          content: Text(
                                              answer
                                          ),
                                          duration: Duration(seconds: 5),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            snackBar);
                                      }
                                    }
                                  },
                                  child: Text(
                                      model.toEdit() ? "Excluir" : 'Limpar',
                                      style: TextStyle(color: Colors.white,fontSize: 22.0)
                                  ),
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

  Widget makeTable(int size, List themes, DataModel model){
    var dts = DTS(themes, model,
        (index) async{
          await model.change(id: themes[index]['id']);
          setState(() {
            _nameController.text = model.information['data']['name'];
            _qntController.text = model.information['data']['qntd'];
          });
        });
    return PaginatedDataTable(
        header: Text('Temas'),
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
                "Quantidade",
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

  List themes;
  DataModel model;
  Function update;

  DTS(this.themes,this.model,this.update);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
        onSelectChanged: (v) async{
          update(index);
        },
        index: index,
        cells: [
          DataCell(Text('${themes[index]['id']}')),
          DataCell(Text('${themes[index]['name']}')),
          DataCell(Text('${themes[index]['qntd']}'))
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => themes.length;

  @override
  int get selectedRowCount => 0;

}



