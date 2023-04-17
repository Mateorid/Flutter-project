import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles.dart';

class AddPetCard extends StatelessWidget {
  const AddPetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 70,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  color: MAIN_GREEN,
                  width: 70,
                  height: 70,
                  child: Icon(Icons.pets, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ADD PET',
                        style: TextStyle(
                            color: DARK_GREEN, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: MAIN_GREEN),
                      onPressed: () => {context.pushNamed("create_pet")},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
