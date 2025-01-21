import 'package:flutter/material.dart';
import 'package:services/constants/constants.dart';
import 'package:services/utils/utils.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode nextNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height:40,width:37 ,child: Image.asset('assets/images/logo.png')),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor2,
                    border: Border.all(width: 1,color: primaryColor),
                    borderRadius: BorderRadius.circular(31)
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8,right: 21,bottom: 8,left: 21),
                      child: Text('Services'),
                    )),
                SizedBox(height: 10,),
                Text(
                  'Welcome to hospital\nAssistant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20,),
                Image.asset('assets/images/firsticon.png'),
                SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient Name',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor2
                      ),
                      child: TextFormField(
                        controller: nameController,
                        focusNode: nameNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Default border color
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Border color when the field is not focused
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Border color when the field is focused
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Border color for validation errors
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent, // Border color when focused with an error
                              width: 2.0,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          Util.fieldFocusChange(context, nameNode, phoneNode);
                        },
                      ),

                    ),
                    SizedBox(height: 10,),
                    Text('Contact Number'),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor2
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        focusNode: phoneNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Default border color
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Border color when the field is not focused
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor, // Border color when the field is focused
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, // Border color for validation errors
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent, // Border color when focused with an error
                              width: 2.0,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          Util.fieldFocusChange(context, nameNode, phoneNode);
                        },
                      ),

                    ),
                  ],
                ),
                SizedBox(height: 10,),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: GestureDetector(
                   onTap: (){},
                   child: Container(
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       color:primaryColor
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Center(child: Text('Next',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w400),)),
                     ),
                   ),
                 ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
