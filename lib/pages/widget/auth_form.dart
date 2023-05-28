import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitAuthFormFn});

  final Function(
    String email,
    String userName,
    String password,
    bool isLogin,
  ) submitAuthFormFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String username = '';
  String password = '';

  void submitForm() {
    if (_formKey.currentState != null) {
      // jika validate sudah benar, maka bisa di save agar On Saved diterima,
      // Kalau model terbaru sekarang menggunakan TextEditingController
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        //
        widget.submitAuthFormFn(email, username, password, _isLogin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key('email'),
              initialValue: "pravasta@gmail.com",
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Mohon Masukkan email yang benar';
                }
                return null;
              },
              onSaved: (newValue) {
                email = newValue ?? "";
              },
            ),
            const SizedBox(height: 10),
            if (!_isLogin)
              TextFormField(
                initialValue: 'pravasta',
                key: const Key('userName'),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4) {
                    return 'Username minimal memiliki 4 karakter';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  username = newValue ?? "";
                },
              ),
            if (!_isLogin) const SizedBox(height: 10),
            TextFormField(
              key: const Key('password'),
              initialValue: 'Cobacoba12',
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'Password minimal memiliki 6 karakter';
                }
                return null;
              },
              onSaved: (newValue) {
                password = newValue ?? "";
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                submitForm();
              },
              child: Text(_isLogin ? 'Masuk' : 'Daftar'),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Daftar Akun Baru' : 'Sudah Punya Akun'),
            ),
          ],
        ));
  }
}
