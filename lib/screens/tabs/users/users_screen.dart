import 'package:flutter/material.dart';
import 'package:gadget_shop/data/models/user_model.dart';
import 'package:gadget_shop/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: context.read<UsersViewModel>().listenUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            List<UserModel> list = snapshot.data as List<UserModel>;
            return ListView(
              children: [
                ...List.generate(
                  list.length,
                  (index) {
                    UserModel user = list[index];
                    return ListTile(
                      leading: Image.network(
                        user.imageUrl,
                        width: 50,
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.userDocId),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<UsersViewModel>()
                                    .deleteUser(user.userDocId, context);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
