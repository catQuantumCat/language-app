import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/auth/login/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userRepo: getIt<UserRepo>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.background,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              // Login successful, router will handle redirection to home
            } else if (state.status == LoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: context.colorTheme.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(context),
                  const SizedBox(height: 48),
                  _buildLoginForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.language,
          size: 80,
          color: context.colorTheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Chào mừng trở lại',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorTheme.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Đăng nhập để tiếp tục hành trình học ngôn ngữ của bạn',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildUsernameField(context),
        const SizedBox(height: 16),
        _buildPasswordField(context),
        const SizedBox(height: 24),
        _buildLoginButton(context),
        const SizedBox(height: 16),
        _buildRegisterText(context),
      ],
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'Tên đăng nhập',
            hintText: 'Nhập tên đăng nhập của bạn',
            prefixIcon: Icon(
              Icons.person,
              color: context.colorTheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.colorTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: context.colorTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            hintText: 'Nhập mật khẩu của bạn',
            prefixIcon: Icon(
              Icons.lock,
              color: context.colorTheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.colorTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: context.colorTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: state.status == LoginStatus.loading
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorTheme.primary,
            foregroundColor: context.colorTheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: state.status == LoginStatus.loading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.colorTheme.onPrimary,
                    ),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn chưa có tài khoản? ",
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () {
            context.go('/register');
          },
          child: Text(
            'Đăng ký',
            style: TextStyle(
              color: context.colorTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
