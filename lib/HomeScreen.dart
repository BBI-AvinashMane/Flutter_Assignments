import 'package:flutter/material.dart';
import 'package:validation_form/main.dart';
import 'package:validation_form/profile_ui.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

RegExp get _emailRegex => RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
RegExp get _passwordRegex => RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');//Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:

class _HomescreenState extends State<Homescreen> {
  String _email ="";
  String _password="";
  String _msg="";
  final emailcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
  @override
  void dispose() {
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Login Form"),
      ),
      
      body: Container(
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailcontroller,
                  decoration: 
                  const  InputDecoration(
                    label: Text("email")
                  ),
                  
                  onChanged: (value){
                    setState(() {
                      _email =value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(label:Text("Password") ),
                  controller: passwordcontroller,
                 
                   onChanged: (value){
                    setState(() {
                      _password=value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: (){
                      final val1= emailValidater(_email);
                      final va2 = passwordValidater(_password);


                      print(val1 +""+va2);
                      
                      if(emailValidater(_email)=="" && passwordValidater(_password)==""){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyWidget()),
                            );
                      }
                  
                  }, child: const Text('Login!')),
              ),
              Text(emailValidater(_email)),
              Text(passwordValidater(_password)),
            ],
          ),
        ),),
    );
  }
  String emailValidater(String _email){
         if(_email==null || _email.isEmpty){
             return "please enter email address";
            }
          if(!_emailRegex.hasMatch(_email)){
             return "email address not valid";
            }
            return "";
  }
  String passwordValidater(String _password){
         if(_password==null || _password.isEmpty){
             return "please enter passwrd";
            }
          if(!_passwordRegex.hasMatch(_password)){

            return "password is weak please include Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character";
          }
            return "";
  }
}