import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../domain/entities/ai_route.dart';
import '../../domain/entities/first_aid_protocol.dart';
import '../../domain/usecases/route_situation.dart';
import '../providers/settings_provider.dart';
import '../widgets/call_115_button.dart';
import '../widgets/clinical_warning_banner.dart';
import '../widgets/network_chip.dart';

/// Mô tả tình huống -> AI chọn MÃ phác đồ -> mở phác đồ từ Drift.
/// Không hiển thị văn bản do LLM sinh. Luôn có nút bỏ qua (sàng lọc tĩnh)
/// và Gọi 115; người dùng không phải chờ AI.
class DescribeSituationScreen extends ConsumerStatefulWidget {
  const DescribeSituationScreen({super.key});

  static const skipLabel = 'Bỏ qua AI, sàng lọc ngay';
  static const submitLabel = 'Tìm phác đồ phù hợp';
  static const referenceLabel = 'KẾT QUẢ THAM KHẢO';
  static const privacyNotice =
      'Văn bản bạn nhập sẽ được gửi qua Internet tới máy chủ của nhóm FirstAid '
      'và dịch vụ AI Gemini (Google, bên thứ ba) để chọn phác đồ có sẵn. '
      'Không nhập họ tên, số điện thoại, địa chỉ.';
  static const consentTitle = 'Gửi mô tả lên máy chủ?';
  static const consentAccept = 'Đồng ý và gửi';
  static const consentDecline = 'Không đồng ý';

  @override
  ConsumerState<DescribeSituationScreen> createState() =>
      _DescribeSituationScreenState();
}

sealed class _Phase {
  const _Phase();
}

class _Idle extends _Phase {
  const _Idle();
}

class _Processing extends _Phase {
  const _Processing(this.stage, this.chars);
  final AiRouteStage stage;
  final int chars;
}

class _Done extends _Phase {
  const _Done(this.outcome);
  final RouteSituationOutcome outcome;
}

class _DescribeSituationScreenState
    extends ConsumerState<DescribeSituationScreen> {
  final _controller = TextEditingController();
  StreamSubscription<RouteSituationUpdate>? _sub;
  late _Phase _phase = _initialPhase();
  bool _showEmptyError = false;

  /// R-33: chưa cấu hình máy chủ AI thì hiện thẻ fallback ngay từ đầu
  /// (vẫn nhập được để kiểm tra từ khóa 115 trên máy).
  _Phase _initialPhase() => ref.read(aiRouterRepositoryProvider).isConfigured
      ? const _Idle()
      : const _Done(FallbackToTriage(FallbackReason.notConfigured));

  /// Gắn vào vùng trạng thái để tự cuộn tới khi có kết quả (màn nhỏ hoặc bàn
  /// phím ảo có thể đẩy thẻ kết quả ra ngoài vùng nhìn thấy).
  final _outcomeKey = GlobalKey();

  void _revealOutcome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _outcomeKey.currentContext;
      if (!mounted || ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 200),
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _showEmptyError = true);
      return;
    }
    setState(() => _showEmptyError = false);

    await _sub?.cancel();
    if (!mounted) return;
    setState(() => _phase = const _Processing(AiRouteStage.sending, 0));
    _sub = ref
        .read(routeSituationProvider)
        .call(text, confirmRemote: _confirmRemote)
        .listen((u) {
          if (!mounted) return;
          setState(() {
            _phase = switch (u) {
              RouteProgress(:final stage, :final receivedChars) => _Processing(
                stage,
                receivedChars,
              ),
              RouteDone(:final outcome) => _Done(outcome),
            };
          });
          if (u is RouteDone) _revealOutcome();
        });
  }

  /// Gọi bởi use case ngay trước khi gửi lên mạng: lần đầu thì hỏi đồng ý.
  Future<bool> _confirmRemote() async {
    if (ref.read(settingsProvider).aiPrivacyConsent) return true;
    if (!mounted) return false;
    final accepted = await _askConsent();
    if (accepted && mounted) {
      await ref.read(settingsProvider.notifier).setAiPrivacyConsent(true);
    }
    return accepted;
  }

  Future<bool> _askConsent() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.privacy_tip_outlined),
        title: const Text(DescribeSituationScreen.consentTitle),
        content: const SingleChildScrollView(
          child: Text(
            '${DescribeSituationScreen.privacyNotice}\n\n'
            'Máy chủ của nhóm được thiết kế không ghi nội dung mô tả vào log. '
            'AI chỉ chọn phác đồ có sẵn trong cẩm nang, không chẩn đoán.\n\n'
            'Nếu không đồng ý, bạn vẫn dùng được sàng lọc offline và nút Gọi 115. '
            'Có thể đổi lựa chọn trong Cài đặt.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(DescribeSituationScreen.consentDecline),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(DescribeSituationScreen.consentAccept),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Hủy yêu cầu AI (nếu có) và chuyển ngay sang sàng lọc tĩnh.
  void _skipToTriage() {
    _sub?.cancel();
    _sub = null;
    context.pushReplacement('/triage');
  }

  @override
  Widget build(BuildContext context) {
    final processing = _phase is _Processing;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Mô tả tình huống')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: NetworkChip(),
                  ),
                  const SizedBox(height: 8),
                  // R-33: chưa cấu hình AI thì không có gì được gửi đi.
                  if (ref.watch(aiRouterRepositoryProvider).isConfigured) ...[
                    const _Notice(
                      icon: Icons.privacy_tip_outlined,
                      text: DescribeSituationScreen.privacyNotice,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _controller,
                    enabled: !processing,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: RouteSituation.maxLength,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Chuyện gì đang xảy ra?',
                      hintText: 'Ví dụ: tay bị bỏng do nước sôi',
                      errorText: _showEmptyError
                          ? 'Hãy nhập mô tả ngắn về tình huống.'
                          : null,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 56),
                    child: FilledButton.icon(
                      onPressed: processing ? null : _submit,
                      icon: const Icon(Icons.search),
                      label: const Text(DescribeSituationScreen.submitLabel),
                    ),
                  ),
                  const SizedBox(height: 16),
                  KeyedSubtree(
                    key: _outcomeKey,
                    child: switch (_phase) {
                      _Idle() => Text(
                        'AI chỉ gợi ý một phác đồ có sẵn trong cẩm nang trên máy, '
                        'không chẩn đoán. Cần mạng.',
                        style: text.bodyMedium,
                      ),
                      _Processing(:final stage, :final chars) => _ProgressView(
                        stage: stage,
                        chars: chars,
                      ),
                      _Done(:final outcome) => switch (outcome) {
                        RoutedToProtocol(:final protocol) => _ResultCard(
                          protocol: protocol,
                        ),
                        EmergencyCall115(:final source, :final protocol) =>
                          _EmergencyCard(source: source, protocol: protocol),
                        FallbackToTriage(:final reason) => _FallbackCard(
                          reason: reason,
                          onStartTriage: _skipToTriage,
                        ),
                      },
                    },
                  ),
                ],
              ),
            ),
            Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 56,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: _skipToTriage,
                        icon: const Icon(Icons.fast_forward),
                        label: const Text(DescribeSituationScreen.skipLabel),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Call115Button(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

String stageLabel(AiRouteStage s) => switch (s) {
  AiRouteStage.sending => 'Đang gửi mô tả…',
  AiRouteStage.received => 'Máy chủ đã nhận mô tả…',
  AiRouteStage.rulesMatched => 'Đang kiểm tra dấu hiệu nguy cấp…',
  AiRouteStage.retrieved => 'Đang tìm phác đồ trong cẩm nang…',
  AiRouteStage.aiSelecting => 'AI đang chọn phác đồ…',
};

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.stage, required this.chars});

  final AiRouteStage stage;
  final int chars;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.hourglass_top),
              const SizedBox(width: 8),
              Expanded(child: Text(stageLabel(stage), style: text.titleMedium)),
            ],
          ),
          if (chars > 0) ...[
            const SizedBox(height: 4),
            Text('Đang nhận phản hồi ($chars ký tự)'),
          ],
          const SizedBox(height: 8),
          Text(
            'Không cần chờ: bấm "${DescribeSituationScreen.skipLabel}" '
            'hoặc Gọi 115 bất cứ lúc nào.',
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.protocol});

  final FirstAidProtocol protocol;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  DescribeSituationScreen.referenceLabel,
                  style: text.labelLarge?.copyWith(color: scheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'AI gợi ý phác đồ dưới đây trong cẩm nang trên máy. Đây không '
              'phải chẩn đoán. Nếu nguy hiểm tính mạng, gọi 115.',
            ),
            const SizedBox(height: 12),
            Text(protocol.title, style: text.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Nguồn: ${protocol.citations.join('; ')}',
              style: text.bodySmall,
            ),
            Text(
              'Phiên bản ${protocol.version} • cập nhật ${protocol.updatedAt}',
              style: text.bodySmall,
            ),
            if (protocol.requiresClinicalWarning) ...[
              const SizedBox(height: 12),
              const ClinicalWarningBanner(),
            ],
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: FilledButton.icon(
                onPressed: () => context.push('/protocols/${protocol.code}'),
                icon: const Icon(Icons.list_alt),
                label: const Text('Mở hướng dẫn từng bước'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({required this.source, required this.protocol});

  final Call115Source source;
  final FirstAidProtocol? protocol;

  static const title = 'Có dấu hiệu nguy cấp: GỌI 115 NGAY';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final p = protocol;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.error, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: scheme.onErrorContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: text.titleLarge?.copyWith(
                    color: scheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(switch (source) {
            Call115Source.localKeywords =>
              'Phát hiện từ khóa nguy cấp ngay trên máy (không cần mạng, '
                  'không gửi đi). Đây không phải chẩn đoán.',
            Call115Source.serverRules =>
              'Theo quy tắc cố định của máy chủ (không phải AI). '
                  'Đây không phải chẩn đoán.',
          }, style: TextStyle(color: scheme.onErrorContainer)),
          const SizedBox(height: 12),
          const Call115Button(),
          if (p != null) ...[
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: FilledButton.tonalIcon(
                onPressed: () => context.push('/protocols/${p.code}'),
                icon: const Icon(Icons.list_alt),
                label: Text('Trong lúc chờ: ${p.title}'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String fallbackMessage(FallbackReason r) => switch (r) {
  FallbackReason.emptyInput => 'Chưa có mô tả.',
  FallbackReason.consentDeclined =>
    'Bạn chưa đồng ý gửi mô tả lên máy chủ nên AI không được dùng.',
  FallbackReason.offline => 'Không có mạng hoặc không kết nối được máy chủ AI.',
  FallbackReason.timeout => 'AI phản hồi quá lâu nên đã dừng chờ.',
  FallbackReason.serverError => 'Máy chủ AI đang lỗi hoặc quá tải.',
  FallbackReason.invalidResponse =>
    'Phản hồi của AI không hợp lệ nên không được dùng.',
  FallbackReason.uncertain =>
    'AI không chắc chắn, hoặc tình huống nằm ngoài cẩm nang.',
  FallbackReason.codeNotAllowed =>
    'AI trả về phác đồ không có trong cẩm nang trên máy nên không được dùng.',
  FallbackReason.notConfigured => 'Ứng dụng chưa được cấu hình máy chủ AI.',
};

class _FallbackCard extends StatelessWidget {
  const _FallbackCard({required this.reason, required this.onStartTriage});

  final FallbackReason reason;
  final VoidCallback onStartTriage;

  static const startLabel = 'Bắt đầu sàng lọc offline';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final icon = switch (reason) {
      FallbackReason.offline => Icons.wifi_off,
      FallbackReason.timeout => Icons.timer_off,
      FallbackReason.uncertain => Icons.help_outline,
      _ => Icons.error_outline,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(fallbackMessage(reason), style: text.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Chuyển sang sàng lọc bằng câu hỏi Có/Không (chạy không cần mạng). '
              'Nếu nguy hiểm tính mạng, gọi 115.',
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: FilledButton.icon(
                onPressed: onStartTriage,
                icon: const Icon(Icons.alt_route),
                label: const Text(startLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
