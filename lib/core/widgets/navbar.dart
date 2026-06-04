import 'package:flutter/material.dart';
import 'package:irisense/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/app/app_viewmodel.dart';
import 'package:irisense/core/services/auth_service.dart';

class Notch extends StatefulWidget {
  const Notch({super.key});

  @override
  State<Notch> createState() => _NotchState();
}

class _NotchState extends State<Notch> {
  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    final auth = Provider.of<AuthService>(context);
    final isPatient = auth.isLoggedIn && auth.currentUser?.role == 'patient';

    return GestureDetector(
      onTap: () {
        if (!appViewModel.navbar_isOpen) {
          setState(() {
            appViewModel.navbar_isOpen = true;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        width: isPatient ? 380 : 300,
        height: appViewModel.navbar_isOpen ? 85.0 : 25.0,
        decoration: BoxDecoration(
          color: AppColors.accentGray,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(WidgetDetails.borderRadius - 4),
            bottomRight: Radius.circular(WidgetDetails.borderRadius - 4),
          ),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: appViewModel.navbar_isOpen 
              ? _buildExpandedContent(appViewModel) 
              : _buildCollapsedContent(),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: SizedBox(
          height: 20,
          width: 20,
          child: GazeIcons.up,
        ),
      ),
    );
  }

  Widget _buildExpandedContent(AppViewModel appViewModel) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final isPatient = auth.isLoggedIn && auth.currentUser?.role == 'patient';
    final l10n = AppLocalizations.of(context)!;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildMenuItem(
                icon: GazeIcons.left,
                label: l10n.settings,
                onTap: () => _handleNavigation(appViewModel, 0),
              ),
            ),
            Expanded(
              child: _buildMenuItem(
                icon: GazeIcons.up,
                label: l10n.textEntry,
                onTap: () => _handleNavigation(appViewModel, 1),
              ),
            ),
            Expanded(
              child: _buildMenuItem(
                icon: GazeIcons.right,
                label: l10n.quickChat,
                onTap: () => _handleNavigation(appViewModel, 2),
              ),
            ),
            if (isPatient)
              Expanded(
                child: _buildMenuItem(
                  icon: GazeIcons.down,
                  label: l10n.messages,
                  onTap: () => _handleNavigation(appViewModel, 3),
                ),
              ),
          ],
        ),
    );
  }

  void _handleNavigation(AppViewModel viewModel, int pageIndex) {
    setState(() {
      viewModel.goToPage(pageIndex);
      viewModel.navbar_isOpen = false;
    });
  }

  Widget _buildMenuItem({
    required Widget icon, 
    required String label, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24, 
            width: 24, 
            child: icon
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 12, 
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}