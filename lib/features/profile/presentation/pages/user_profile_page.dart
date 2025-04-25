import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/core/utils/util_functions.dart';
import 'package:megatronix/features/auth/presentation/pages/login_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/features/profile/presentation/pages/create_profile_page.dart';
import 'package:megatronix/features/profile/presentation/widgets/profile_tiles.dart';
import 'package:megatronix/features/profile/provider/profile_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
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
          builder: (context) => const LogInPage(),
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
          builder: (context) => CreateProfilePage(user: authState.user!),
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
      MaterialPageRoute(builder: (context) => const LogInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    if (_isLoading ||
        !_isInitialized ||
        authState.isLoading ||
        profileState.isLoading) {
      return CustomScaffold(
        title: 'Profile',
        child: Center(child: LoadingWidget()),
      );
    }

    if (authState.user == null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      return CustomScaffold(
        title: 'Profile',
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
                  MaterialPageRoute(builder: (context) => const LogInPage()),
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
      return CustomScaffold(
        title: 'Profile',
        child: Center(
          child: Text(
            'Failed to load Profile',
          ),
        ),
      );
    }

    if (profileState.profile != null) {
      return CustomScaffold(
        title: 'Profile',
        isDisabled: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              if (profileState.profile!.profilePicture != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(62.5),
                  child: Image.network(
                    profileState.profile!.profilePicture!,
                    height: 125,
                    width: 125,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 25),
              Column(
                children: [
                  Text(
                    profileState.profile!.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        // width: size.width * 0.8,
                        child: Text(
                          profileState.profile!.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                      if (profileState.profile!.isVerified)
                        const Icon(
                          Icons.verified,
                          color: AppTheme.primaryRedAccentColor,
                          size: 20,
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CupertinoListSection.insetGrouped(
                  margin: const EdgeInsets.all(5),
                  backgroundColor: AppTheme.darkBackground,
                  separatorColor: AppTheme.dividerColor,
                  dividerMargin: -40,
                  decoration: BoxDecoration(
                    color: AppTheme.blackBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  header: Text(
                    'Personal Details',
                    style: TextStyle(
                      color: AppTheme.whiteBackground,
                      fontSize: 18,
                      fontFamily: 'FiraCode',
                    ),
                  ),
                  footer: Text(
                    '- You can long press GID to copy\n- Click on GID to view registration details\n- Scroll the GID to view all GIDs',
                    style: TextStyle(
                      color: AppTheme.whiteBackground,
                      fontSize: 12,
                      fontFamily: 'FiraCode',
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
              SizedBox(height: 25),
              CustomButton(
                onPressed: _logOut,
                buttonText: 'LogOut',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

    return CustomScaffold(
      title: 'Profile',
      child: Center(
        child: Text('Failed to load profile'),
      ),
    );
  }
}
