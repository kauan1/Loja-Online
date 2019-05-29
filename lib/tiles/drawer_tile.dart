import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon,this.text,this.controller,this.page);//recebe o icone, texto e o controler do custom_drawer

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(//cria as opções do menu lateral
        onTap: (){//função de cada opção lateral
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(//o objeto em si do menu lateral
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page.round() == page ?
                    Theme.of(context).primaryColor:
                    Colors.grey[700],//aqui se coloca a cor do icone da opção
                // do menu lateral que muda quando esta naquela pagina
              ),
              SizedBox(width: 32.0,),//espaço entre o icone e o texto
              Text(
                  text,
                style: TextStyle(
                  fontSize: 18.0,
                  color: controller.page.round() == page ?
                      Theme.of(context).primaryColor:
                      Colors.grey[700]//aqui se coloca a cor das letra da opção
                  // do menu lateral que muda quando esta naquela pagina
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
