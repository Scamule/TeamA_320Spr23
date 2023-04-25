import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_application_1/profile_page.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget{
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(LineAwesomeIcons.angle_left)),
        //title: Text("Edit Profile", style: Theme.of(context).textTheme.headlineMedium),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*
            Stack(
              children: [
                
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  */
                  /*
                  Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.purple),
                    child: const Icon(
                      LineAwesomeIcons.
                    ),
                  ),
                  
                  ),
              ] 
                ),

              ],
            ),*/
            const SizedBox(height: 30),
            Text("Enter new email/password", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),
            const Divider(),
            Form(child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(label: Text("Email"), prefixIcon: Icon(Icons.person_outline_rounded)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Password"), prefixIcon: Icon(Icons.fingerprint)),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () { Navigator.of(context).pop(true);
                      /*
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
                  );*/},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, side: BorderSide.none, shape: const StadiumBorder()),
                    
                    child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormFieldTheme{
  TextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
  const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: Colors.purple,
    floatingLabelStyle: TextStyle(color: Colors.purple),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.purple), 
    )
  );
}
