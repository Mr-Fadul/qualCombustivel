import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
    home: Home(),
        ),
      );
    }



class Home extends StatefulWidget{
      @override
    _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home>{
  //variavel controlador o flutter já gerencia a mudança de status da variavel
  TextEditingController precoGasolinaController = TextEditingController();
  TextEditingController precoEtanolController = TextEditingController();
  TextEditingController coeficienteController = TextEditingController();
  String _info = "Informe os preços dos combustiveis";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields(){
    precoEtanolController.text="";
    precoGasolinaController.text="";
    coeficienteController.text="";
    setState(() {
      _info = "Informe os preços dos combustiveis!";
      _formKey = GlobalKey<FormState>();
    });
  } 
  
  void _calcularMelhorCombustivel(){
    setState(() {
      double precoEtanol = double.parse(precoEtanolController.text);
      double precoGasolina = double.parse(precoGasolinaController.text);
      int coeficientePorcentagem = int.parse(coeficienteController.text);
      double coeficiente = precoEtanol / precoGasolina;
      print(coeficiente);
      _info = (coeficiente <= (coeficientePorcentagem/100)) ? "Etanol é a melhor opção" : "Gasolina é a melhor opção"; 
    });
    
  }

  @override
  Widget build(BuildContext context) {
    
 
    return Scaffold(

      appBar: AppBar(
        title: Text("Qual combustível comprar?"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), 
          onPressed: _resetFields)
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child:Form(
          key: _formKey,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[          
              Icon(Icons.time_to_leave, size:100.0, color: Colors.red),            
              //input da porcentagem 
              TextFormField(
                controller: coeficienteController,
                keyboardType: TextInputType.number,
                inputFormatters: 
                  <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ], 
                decoration: InputDecoration(
                  labelText: "Coeficiente ideal %:",
                  labelStyle: TextStyle(color: Colors.red),
                  hintText: 'ex: 100%',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 20.0),
                validator: (value){
                  if(value.isEmpty){
                    return "Informe o coeficiente ideal para o tipo de veiculo!";
                  }
                },
              ),
              //input da gasolina
              TextFormField(
                controller: precoGasolinaController,
                keyboardType: TextInputType.number,
                inputFormatters: 
                  <TextInputFormatter>[
                    WhitelistingTextInputFormatter(RegExp("[0-9 /.]")),
                    BlacklistingTextInputFormatter(RegExp("[a-zA-Z]")),
                  ], 
                decoration: InputDecoration(
                  labelText: "Gasolina R\$:",
                  labelStyle: TextStyle(color: Colors.red),
                  hintText: 'ex:R\$\ 4,50',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 20.0),
                validator: (value){
                  if(value.isEmpty){
                    return "Informe o preço da Gasolina!";
                  }
                },
              ),
              //input do etanol
              TextFormField(
                controller: precoEtanolController,
                keyboardType: TextInputType.number,
                inputFormatters: 
                  <TextInputFormatter>[
                    WhitelistingTextInputFormatter(RegExp("[0-9 /.]")),
                    BlacklistingTextInputFormatter(RegExp("[a-zA-Z]")),
                  ],
                decoration: InputDecoration(
                  labelText: "Etanol R\$:",
                  labelStyle: TextStyle(color: Colors.red),
                  hintText: 'ex:R\$\ 4,50',
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 20.0),
                validator: (value){
                  if(value.isEmpty){
                    return "Informe o preço da Etanol!";
                  }
                },
              ),
              
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child:Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed:(){
                      if(_formKey.currentState.validate()){
                      _calcularMelhorCombustivel();
                      }
                      //recolhe o teclado ao apertar o botão
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    } ,
                    child: Text(
                      "Calcular",
                       style: TextStyle(color: Colors.white, fontSize: 20.0),    
                    ),
                     color: Colors.blue
                  )
                ),
              ),
              Text(_info, textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontSize: 20.0),),
            ],
          )
        )
      )
    );
  }
}