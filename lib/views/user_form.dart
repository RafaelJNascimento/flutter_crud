import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/users.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(User? user) {
    if (user != null) {
      _formData['id'] = user.id!;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments as User?;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formulário de usuário',
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_form.currentState!.validate()) {
                _form.currentState?.save();
                Provider.of<Users>(
                  context,
                  listen: false,
                ).put(
                  User(
                    id: _formData['id'],
                    name: _formData['name'].toString(),
                    email: _formData['email'].toString(),
                    avatarUrl: _formData['avatarUrl'] != null
                        ? _formData['avatarUrl'].toString()
                        : '',
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          15,
        ),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                initialValue: _formData['name'],
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome inválido';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome muito pequeno. No mínimo três letras!';
                  }
                  return null;
                },
                onSaved: (newValue) => _formData['name'] = newValue!,
              ),
              TextFormField(
                initialValue: _formData['email'],
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                onSaved: (newValue) => _formData['email'] = newValue!,
              ),
              TextFormField(
                initialValue: _formData['avatarUrl'],
                decoration: const InputDecoration(
                  labelText: "URL do Avatar",
                ),
                onSaved: (newValue) => _formData['avatarUrl'] = newValue!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
