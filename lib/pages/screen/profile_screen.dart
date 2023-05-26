import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todos/models/users_model.dart';
import 'package:todos/services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imageFile = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<UserModel>(
          stream: DatabaseService().dataUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error!}'),
              );
            }

            // Untuk mengambil data
            final dataUser = snapshot.data as UserModel;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 150,
                  color: Colors.deepPurple,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? xFile = await _imageFile.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 30,
                          );
                          if (xFile != null) {
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              // Tidak boleh dihilangin dialog nya dengan ditekan area luar
                              barrierDismissible: false,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Mengupload Foto'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              },
                            );
                            await DatabaseService().uploadUserImage(
                              File(
                                xFile.path,
                              ),
                            );
                            if (!mounted) return;
                            Navigator.pop(context);
                          }
                        },
                        child: CircleAvatar(
                          minRadius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: dataUser.imageUrl != ''
                              ? NetworkImage(dataUser.imageUrl)
                              : null,
                          child: dataUser.imageUrl == ''
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        dataUser.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          String tempUsername = '';
                          bool? isEditUsername = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Ubah UserName'),
                                content: TextFormField(
                                  onChanged: (value) {
                                    tempUsername = value;
                                  },
                                  initialValue: dataUser.username,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text(
                                      'Batal',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Simpan'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (isEditUsername != null && isEditUsername) {
                            DatabaseService().updateUserName(tempUsername);
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: const Text(
                    'Data User',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text('Email'),
                              ),
                              const Text('= '),
                              Text(dataUser.email)
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text('Phone'),
                              ),
                              const Text('= '),
                              Text(dataUser.phone)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Keluar'),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
