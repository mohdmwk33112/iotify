import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:untitled/core/platform_widgets_new.dart' as platform;
import '../../routes.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Authentication'),
        material: (_, __) => MaterialAppBarData(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          title: CupertinoSlidingSegmentedControl<int>(
            groupValue: _tabController.index,
            onValueChanged: (value) {
              if (value != null) {
                _tabController.animateTo(value);
              }
            },
            children: const {
              0: Text('Login'),
              1: Text('Register'),
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLoginForm(),
          _buildRegisterForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          platform.PlatformWidgets.textField(
            context: context,
            controller: _emailController,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          platform.PlatformWidgets.textField(
            context: context,
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 24),
          platform.PlatformWidgets.button(
            context: context,
            onPressed: () {
              // _handleLogin();
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          platform.PlatformWidgets.textField(
            context: context,
            controller: _emailController,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          platform.PlatformWidgets.textField(
            context: context,
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 24),
          platform.PlatformWidgets.button(
            context: context,
            onPressed: () {
              // _handleRegister();
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  // void _handleLogin() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Handle login logic
  //   }
  // }

  // void _handleRegister() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Handle registration logic
  //   }
  // }
} 