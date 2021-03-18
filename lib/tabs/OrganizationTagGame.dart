import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:trimemoria/models/DataModel.dart';

class OrganizationTagGame extends StatefulWidget {

  @override
  _OrganizationTagGameState createState() => _OrganizationTagGameState();
}

class _OrganizationTagGameState extends State<OrganizationTagGame> {

  final _nameController = TextEditingController();
  final _stateForm = GlobalKey<FormState>();
  List tags = [];
  int column = 0;
  int row = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5.0),
      child: ScopedModelDescendant<DataModel>(
          builder: (context, child, model){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Form(
                    key: _stateForm,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  color: Color(0xFFFF8306)
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
                        Card(
                          child: ExpansionTile(
                              title: Text(
                                  "Matrix's configuration",
                                  style: TextStyle(
                                    color: Color(0xFFFF8306)
                                  ),
                              ),
                              leading: Icon(
                                  Icons.grid_on,
                                  color: Color(0xFFFF8306),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    onChanged: (value){
                                      int change = int.parse(value);
                                      int size = change * column;
                                      setState(() {
                                        row = change;
                                        tags = List.filled(size, '');
                                      });
                                    },
                                    initialValue: row.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Rows',
                                        labelStyle: TextStyle(
                                            color: Color(0xFFFF8306)
                                        ),

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    onChanged: (value){
                                      int change = int.parse(value);
                                      int size = change * row;
                                      setState(() {
                                        column = change;
                                        tags = List.filled(size, '');
                                      });
                                    },
                                    initialValue: column.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Columns',
                                        labelStyle: TextStyle(
                                            color: Color(0xFFFF8306)
                                        )
                                    ),
                                  ),
                                )
                              ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          child: ExpansionTile(
                            title: Text(
                                "Tag's configuration",
                                style: TextStyle(
                                  color: Color(0xFFFF8306)
                                ),
                            ),
                            leading: Icon(
                                Icons.credit_card,
                                color: Color(0xFFFF8306),
                            ),
                            children: List<Widget>.generate(tags.length, (index){
                              return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: TextFormField(
                                  initialValue:
                                  (column == 0 || row == 0) ? "" :tags[index],
                                  onChanged: (value){
                                    tags[index] = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Tag',
                                      labelStyle: TextStyle(
                                          color: Color(0xFFFF8306)
                                      )
                                  ),
                                  // ignore: missing_return
                                  validator: (value){
                                    if(value.isEmpty) return "O campo deve ser preenchido";
                                  },
                                ),
                              );
                            }
                            ).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
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
                                    int size = row * column;
                                    if(_stateForm.currentState.validate() && size == tags.length){
                                      Map<String,dynamic> data ={
                                        "name": _nameController.text,
                                        "qntd": size,
                                        "configurationTag": toMap()
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
                                        column = 0;
                                        row = 0;
                                        tags = [];
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
                SizedBox(
                  height: 20.0,
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
      ),
    );
  }

  Widget makeTable(int size, List themes, DataModel model){
    var dts = DTS(themes, model, (index) async{
          await model.change(id: themes[index]['id']);
          String coord = getLastCoordinate(model.information['data']['configurationTag']);
          setState(() {
            _nameController.text = model.information['data']['name'];
            tags = listOfStringTags(model.information['data']['configurationTag']);
            row = int.parse(coord.substring(0,1));
            column = int.parse(coord.substring(1));
          });
        });
    return PaginatedDataTable(
      header: Text('Configuration of Matrix Game'),
      columns: const <DataColumn>[
        DataColumn(
            label: Text("Id",style: TextStyle(fontStyle: FontStyle.italic),)
        ),
        DataColumn(
            label: Text(
              "Configuração",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
        ),
        DataColumn(
            label: Text(
              "Quantidade(Cards)",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
        ),
      ],
      source: dts,
      rowsPerPage: 5,
    );
  }

  List<Map<String,dynamic>> toMap(){
    List<Map<String,dynamic>> aux = [];
    int index = 0;
    for(int i = 0; i < row; i++){
      for(int j = 0; j < column; j++){
        //int key = int.parse("${i+1}${j+1}");
        String key = "${i+1}${j+1}";
        Map<String,dynamic> obj = {
          key: tags[index],
        };
        aux.add(obj);
        index++;
      }
    }
    return aux;
  }

  List<String> listOfStringTags(List<dynamic> configTags){
    return configTags.map((v){
      return v.values.first.toString();
    }).toList();
  }

  String getLastCoordinate(List<dynamic> configTags){
    return configTags.last.keys.first.toString();
  }

}

class DTS extends DataTableSource{

  List configurations;
  DataModel model;
  Function update;

  DTS(this.configurations,this.model,this.update);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
        onSelectChanged: (v) async{
          update(index);
        },
        index: index,
        cells: [
          DataCell(Text('${configurations[index]['id']}')),
          DataCell(Text('${configurations[index]['name']}')),
          DataCell(Text('${configurations[index]['qntd']}'))
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => configurations.length;

  @override
  int get selectedRowCount => 0;

}

