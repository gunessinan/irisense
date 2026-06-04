import 'package:flutter/material.dart';
import 'package:irisense/app/app_viewmodel.dart';
import 'package:irisense/core/constants/classic_theme.dart';
import 'package:irisense/core/services/tracking_service.dart';
import 'package:irisense/features/quickchat/models/quicktexts.dart';
import 'package:irisense/features/quickchat/models/quick_images.dart';
import 'package:provider/provider.dart';
import '../view_models/quickchat_viewmodel.dart';

class QuickChatPage extends StatefulWidget {
  const QuickChatPage({super.key});

  @override
  State<QuickChatPage> createState() => _QuickChatPageState();
}

class _QuickChatPageState extends State<QuickChatPage>
    with AutomaticKeepAliveClientMixin {
  late QuickChatViewModel viewmodel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    viewmodel = QuickChatViewModel(soundService: appViewModel.soundService);
  }

  @override
  void dispose() {
    viewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trackingService = Provider.of<TrackingService>(context);
    final quickChatTexts  = getQuickChatTexts(context);

    trackingService.setActionForPage(2, (gazeType) {
      viewmodel.actionTriggered(gazeType, quickChatTexts);
    });
    trackingService.setHandlesUp(2, true);
    trackingService.setHandlesDown(2, true);

    return AnimatedBuilder(
      animation: viewmodel,
      builder: (context, _) {
        final divider = AppColors.accentGray.withValues(alpha: 0.18);

        return Column(
          children: [
            // --- Üst sıra: 0 · 1 · 2 ---
            Expanded(
              child: Row(
                children: [
                  _Section(num: 0, vm: viewmodel, texts: quickChatTexts),
                  _VDivider(color: divider),
                  _Section(num: 1, vm: viewmodel, texts: quickChatTexts),
                  _VDivider(color: divider),
                  _Section(num: 2, vm: viewmodel, texts: quickChatTexts),
                ],
              ),
            ),
            _HDivider(color: divider),
            // --- Alt sıra: 3 · 4 · 5 ---
            Expanded(
              child: Row(
                children: [
                  _Section(num: 3, vm: viewmodel, texts: quickChatTexts),
                  _VDivider(color: divider),
                  _Section(num: 4, vm: viewmodel, texts: quickChatTexts),
                  _VDivider(color: divider),
                  _Section(num: 5, vm: viewmodel, texts: quickChatTexts),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Bölüm widget'ı ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final int num;
  final QuickChatViewModel vm;
  final List<List<String>> texts;

  const _Section({required this.num, required this.vm, required this.texts});

  static final List<Widget> _icons = [
    GazeIcons.leftup,
    GazeIcons.closed,
    GazeIcons.rightup,
    GazeIcons.left,
    GazeIcons.down,
    GazeIcons.right,
  ];

  @override
  Widget build(BuildContext context) {
    final bool isHovered = vm.hoveredButton == num;
    final bool isBottom  = const {3, 4, 5}.contains(num);
    final bool isLeft    = const {0, 3}.contains(num);
    final bool isRight   = const {2, 5}.contains(num);

    final item = quickChatItems[num][vm.currentPage];

    return Expanded(
      child: GestureDetector(
        onTap: () => vm.button_OnTap(num, texts[num][vm.currentPage]),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: isHovered
              ? AppColors.limeAccent.withValues(alpha: 0.09)
              : Colors.transparent,
          child: Stack(
            children: [
              // Gaze yönü ikonu — köşeye yerleşir
              Positioned(
                top:    isBottom ? null : 32,
                bottom: isBottom ? 14   : null,
                left:   isLeft  ? 14   : (isRight ? null : 0),
                right:  isRight ? 14   : (isLeft  ? null : 0),
                child: isLeft || isRight
                    ? _icons[num]
                    : Center(child: _icons[num]),
              ),

              // Resim — tam merkez (metin yoktur)
              Center(
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.contain,
                    color: isHovered ? AppColors.limeAccent : null,
                    colorBlendMode: isHovered ? BlendMode.srcIn : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ayraç widget'ları ───────────────────────────────────────────────────────

class _VDivider extends StatelessWidget {
  final Color color;
  const _VDivider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, color: color);
}

class _HDivider extends StatelessWidget {
  final Color color;
  const _HDivider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: color);
}
