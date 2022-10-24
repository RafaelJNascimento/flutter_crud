import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';
import '../routes/app_routes.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl.isEmpty
        ? const CircleAvatar(
            child: Icon(
              Icons.person,
            ),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(
              user.avatarUrl,
            ),
          );
    return ListTile(
      leading: avatar,
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                  arguments: user,
                );
              },
              color: Colors.orange,
              icon: const Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Excluir esse usuário',
                    ),
                    content: const Text(
                      'Tem certeza?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(
                          false,
                        ),
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pop(
                          true,
                        ),
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                ).then((confirmed) {
                  if (confirmed) {
                    Provider.of<Users>(
                      context,
                      listen: false,
                    ).remove(user);
                  }
                });
              },
              color: Colors.red,
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
