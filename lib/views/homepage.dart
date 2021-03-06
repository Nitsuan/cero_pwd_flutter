import 'package:cero_pwd/bloc/password_bloc.dart';
import 'package:cero_pwd/data/passwords.dart';
import 'package:cero_pwd/services/network.dart';
import 'package:cero_pwd/views/passwordview.dart';
import 'package:cero_pwd/views/widgets/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
            color: Colors.black,
            iconTheme: IconThemeData(
              color: Colors.grey[400],
              size: 27.0,
            ),
            actionsIconTheme: IconThemeData(
              size: 27.0,
              color: Colors.grey[400],
            ),
          ),
          scaffoldBackgroundColor: Colors.black),
      home: FutureBuilder(
          future: selectAction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return BlocProvider(
                  create: (context) => PasswordBloc(snapshot.data),
                  child: BlocBuilder<PasswordBloc, ApiData>(
                      builder: (context, state) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.settings_outlined,
                          ),
                          onPressed: () {},
                        ),
                        title: Text(
                          "Cero",
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                            ),
                            onPressed: () {
                              PasswordBloc passwordBloc =
                                  context.read<PasswordBloc>();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewPassword(
                                          passwordBloc: passwordBloc)));
                            },
                          )
                        ],
                      ),
                      body: Container(
                        child: RefreshIndicator(
                          backgroundColor: Colors.grey[400],
                          color: Colors.black,
                          onRefresh: () {
                            context.read<PasswordBloc>().add(SelectEvent());
                            return context.read<PasswordBloc>().first;
                          },
                          child: ListView.builder(
                            itemCount: state.getPasswordsList.length,
                            itemBuilder: (context, position) {
                              Password tempPassword =
                                  state.getPasswordsList[position];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  onTap: () {
                                    PasswordBloc _passwordBloc =
                                        BlocProvider.of<PasswordBloc>(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PasswordView(
                                          index: position,
                                          passwordBloc: _passwordBloc,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: Icon(
                                    Icons.apps,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                  title: Hero(
                                    tag: position,
                                    child: Text(
                                      tempPassword.getName,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    tempPassword.getUsername,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.copy_outlined,
                                      color: Colors.grey[700],
                                      size: 31.0,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: tempPassword.getPassword));
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
