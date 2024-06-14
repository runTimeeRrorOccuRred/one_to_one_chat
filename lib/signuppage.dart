import 'package:flutter/material.dart';
import 'package:one_to_one_chatapp/loginpage.dart';
import 'package:one_to_one_chatapp/methods.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey=GlobalKey<FormState>();
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Center(child: CircularProgressIndicator()):Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.8)
                ]
            )
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.black)),
                  SizedBox(height: 20,),
                  TextFormField(

                    decoration: InputDecoration(


                        hintText: 'Enter your name',
                        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.person,color: Colors.grey.shade400,),
                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        )
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name can not be empty';
                      }
                    },

                  ),
                  SizedBox(height: 20,),
                  TextFormField(

                    decoration: InputDecoration(


                        hintText: 'Enter your email',
                        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.email,color: Colors.grey.shade400,),
                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        )
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email can not be empty';
                      }
                    },
                  ),
                  SizedBox(height: 20,),



                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,

                    decoration: InputDecoration(

                        hintText: 'Enter your password',
                        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.lock,color: Colors.grey.shade400,),
                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black),
                        )
                    ),
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password can not be empty';
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(


                            primary: Colors.indigo.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        onPressed: () {
                          if(formKey.currentState!.validate())
                            {
                              setState(() {
                                isLoading=true;
                              });
                              createAccount(nameController.text, emailController.text, passwordController.text).then((user) {
                                if(user!=null)
                                  {
                                    setState(() {
                                      isLoading=false;
                                    });
                                    print('Account creation successfull');
                                  }
                                else
                                  {
                                    print('Account creation failed');
                                  }
                              }

                              );
                            }
                        }, child: Text('SignUp',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 20),)),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account',style: TextStyle(color: Colors.black),),
                      SizedBox(width: 10,),
                      GestureDetector(
                          onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                          },
                          child: Text("Login",style: TextStyle(color: Colors.black,decoration: TextDecoration.underline,
                              decorationColor: Colors.white),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
