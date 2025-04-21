import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/core/utils/util_functions.dart';
import 'package:megatronix/features/auth/presentation/pages/web/login_web_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/features/profile/presentation/pages/web/create_profile_web_page.dart';
import 'package:megatronix/features/profile/presentation/widgets/profile_tiles.dart';
import 'package:megatronix/features/profile/provider/profile_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class UserProfileWebPage extends ConsumerStatefulWidget {
  final bool isMainPage;
  const UserProfileWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  ConsumerState<UserProfileWebPage> createState() => _UserProfileWebPageState();
}

class _UserProfileWebPageState extends ConsumerState<UserProfileWebPage> {
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndProfile();
    });
  }

  Future<void> _checkAuthAndProfile() async {
    setState(() => _isLoading = true);

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.checkAuth();
    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (!authState.isLoading && (authState.user == null)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LogInWebPage(),
        ),
      );
      AppErrorHandler.handleError(
        context,
        'Login Required',
        authState.error?.message ?? 'Please login to continue',
        type: ToastificationType.warning,
      );
      return;
    }

    if (authState.user != null && !authState.user!.profileCreated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CreateProfileWebPage(user: authState.user!),
        ),
      );
      AppErrorHandler.handleError(
        context,
        'Profile Required',
        'Please complete your profile',
        type: ToastificationType.warning,
      );
      return;
    }

    if (authState.user != null && authState.user!.profileCreated) {
      await ref
          .read(profileNotifierProvider.notifier)
          .getProfileByID(authState.user!.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    }
  }

  void _logOut() {
    ref.read(authNotifierProvider.notifier).logOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LogInWebPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final size = MediaQuery.sizeOf(context);
    final isWideScreen = size.width > 1100;

    if (_isLoading ||
        !_isInitialized ||
        authState.isLoading ||
        profileState.isLoading) {
      return CustomWebScaffold(
        title: 'User Profile',
        child: Center(child: LoadingWidget()),
      );
    }

    if (authState.user == null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      return CustomWebScaffold(
        title: 'User Profile',
        isMainPage: widget.isMainPage,
        isDisabled: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You need to login to view profile details',
                style: TextStyle(color: AppTheme.whiteBackground),
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LogInWebPage()),
                ),
                buttonText: 'Login',
              ),
            ],
          ),
        ),
      );
    }

    if (authState.user != null && !authState.user!.verified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppErrorHandler.handleError(
          context,
          'Verification Required',
          'Please verify your email to access all features',
          type: ToastificationType.warning,
        );
      });
    }

    if (profileState.profile == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Failed to load Profile',
          ),
        ),
      );
    }

    if (profileState.profile != null) {
      return CustomWebScaffold(
        title: 'Profile',
        isDisabled: true,
        isMainPage: true,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? size.width * 0.1 : 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    if (profileState.profile!.profilePicture != null)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlueAccentColor
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.network(
                            profileState.profile!.profilePicture!,
                            height: isWideScreen ? 150 : 125,
                            width: isWideScreen ? 150 : 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: isWideScreen ? 32 : 25),
                    Column(
                      children: [
                        Text(
                          profileState.profile!.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: isWideScreen ? 28 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              profileState.profile!.email,
                              style: TextStyle(
                                fontSize: isWideScreen ? 18 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            if (profileState.profile!.isVerified)
                              Icon(
                                Icons.verified,
                                color: AppTheme.primaryBlueAccentColor,
                                size: isWideScreen ? 24 : 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: isWideScreen ? 20 : 15),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: isWideScreen ? 800 : double.infinity,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blackBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              AppTheme.primaryBlueAccentColor,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CupertinoListSection.insetGrouped(
                          backgroundColor: AppTheme.darkBackground,
                          margin: EdgeInsets.all(isWideScreen ? 24 : 16),
                          separatorColor: AppTheme.dividerColor,
                          dividerMargin: -40,
                          header: Text(
                            'Personal Details',
                            style: TextStyle(
                              color: AppTheme.whiteBackground,
                              fontSize: isWideScreen ? 22 : 18,
                              fontFamily: 'DaggerSquare',
                            ),
                          ),
                          footer: Text(
                            '- You can long press GID to copy\n- Click on GID to view registration details',
                            style: TextStyle(
                              color: AppTheme.whiteBackground,
                              fontSize: isWideScreen ? 14 : 12,
                              fontFamily: 'DaggerSquare',
                            ),
                          ),
                          children: [
                            ProfileTiles(
                              leading: 'Institution Name',
                              title: profileState.profile!.college,
                            ),
                            ProfileTiles(
                              leading: 'Dept',
                              title: profileState.profile!.department,
                            ),
                            ProfileTiles(
                              leading: 'Roll',
                              title: profileState.profile!.roll,
                            ),
                            ProfileTiles(
                              leading: 'Year',
                              title: profileState.profile!.year,
                            ),
                            ProfileTiles(
                              leading: 'Contact',
                              title: profileState.profile!.contact,
                            ),
                            ProfileTiles(
                              leading: 'GIDs',
                              title: profileState.profile!.gids,
                              isGID: true,
                            ),
                            ProfileTiles(
                              leading: 'Last Login',
                              title: UtilFunctions.formatDate(
                                profileState.profile!.lastLogin ??
                                    profileState.profile!.createdAt ??
                                    'N/A',
                              ),
                            ),
                            ProfileTiles(
                              leading: 'Email',
                              title: profileState.profile!.isVerified
                                  ? 'Verified'
                                  : 'Not Verified',
                              isVerifiedField: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isWideScreen ? 20 : 25),
                    SizedBox(
                      width: isWideScreen ? 200 : double.infinity,
                      child: CustomButton(
                        onPressed: _logOut,
                        buttonText: 'LogOut',
                        isWebPage: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text('Failed to load profile'),
      ),
    );
  }
}
