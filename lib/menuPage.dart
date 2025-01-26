import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/homePage.dart';

class Menupage extends StatefulWidget {
  const Menupage({super.key});

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'A',),));
              },
                child: Icon(Icons.home,size: 80,color: primaryColor,)),
            Text('Home Care Services',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'B'),));
              },
                child: Icon(Icons.local_hospital,size: 80,color: primaryColor,)),
            Text('Hospital Services',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(type: 'C',),));
              },
                child: Icon(Icons.run_circle,size: 80,color: primaryColor,)),
            Text('Physiotherapist',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)
          ],
        )
      ),
    );
  }
}
