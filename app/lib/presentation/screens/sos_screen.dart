import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../domain/services/location_service.dart';
import '../widgets/call_115_button.dart';

enum _Phase { intro, locating, failure, preview }

/// SOS: giải thích quyền vị trí -> lấy vị trí -> xem trước SMS -> xác nhận.
/// App KHÔNG tự gửi tin nhắn; người dùng tự bấm gửi trong ứng dụng nhắn tin.
class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  static const introText =
      'Để soạn tin nhắn kèm vị trí, app cần quyền vị trí. Vị trí chỉ được lấy '
      'khi bạn bấm nút bên dưới, chỉ dùng để soạn nội dung tin nhắn và không '
      'được gửi đi đâu nếu bạn không tự bấm Gửi. Không cần đăng nhập.';
  static const noAutoSendText =
      'App không tự gửi tin nhắn. Bạn sẽ xem lại nội dung và tự bấm Gửi.';
  static const limitsText =
      'Tọa độ GPS dùng được khi không có Internet (cần nhìn thấy tín hiệu '
      'GPS). Bản đồ và địa chỉ chữ cần Internet nên app không hiển thị. Gọi '
      'và nhắn tin cần sóng di động; mất Internet không có nghĩa là mất sóng.';

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  _Phase _phase = _Phase.intro;
  LocationResult? _location;
  LocationStatus? _failure;
  DateTime? _time;
  final _noteController = TextEditingController();
  bool _opened = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _phase = _Phase.locating);
    final result = await ref.read(getCurrentLocationForSosProvider).call();
    if (!mounted) return;
    if (result.isOk) {
      _enterPreview(result);
    } else {
      setState(() {
        _failure = result.status;
        _phase = _Phase.failure;
      });
    }
  }

  void _enterPreview(LocationResult? location) {
    setState(() {
      _location = location;
      _time = ref.read(clockProvider)();
      _phase = _Phase.preview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS: gửi vị trí')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: switch (_phase) {
            _Phase.intro => _intro(),
            _Phase.locating => _locating(),
            _Phase.failure => _failureView(),
            _Phase.preview => _preview(),
          },
        ),
      ),
    );
  }

  Widget _intro() => ListView(
    children: [
      Text(
        'Vì sao cần quyền vị trí?',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 8),
      const Text(SosScreen.introText),
      const SizedBox(height: 16),
      const Text(SosScreen.limitsText),
      const SizedBox(height: 24),
      _BigButton(
        icon: Icons.my_location,
        label: 'Lấy vị trí của tôi',
        onPressed: _fetchLocation,
      ),
      const SizedBox(height: 12),
      _BigButton(
        icon: Icons.sms,
        label: 'Bỏ qua, soạn tin không có vị trí',
        tonal: true,
        onPressed: () => _enterPreview(null),
      ),
      const SizedBox(height: 24),
      const Call115Button(),
    ],
  );

  Widget _locating() => ListView(
    children: const [
      SizedBox(height: 24),
      Center(child: CircularProgressIndicator()),
      SizedBox(height: 16),
      Center(child: Text('Đang lấy vị trí...')),
      SizedBox(height: 24),
      Call115Button(),
    ],
  );

  Widget _failureView() {
    final status = _failure!;
    final (message, extra) = switch (status) {
      LocationStatus.permissionDenied => (
        'Bạn đã từ chối quyền vị trí.',
        null as Widget?,
      ),
      LocationStatus.permissionDeniedForever => (
        'Quyền vị trí đang bị chặn. Hãy bật lại trong Cài đặt ứng dụng.',
        _BigButton(
          icon: Icons.settings,
          label: 'Mở cài đặt ứng dụng',
          tonal: true,
          onPressed: () => ref.read(locationServiceProvider).openAppSettings(),
        ),
      ),
      LocationStatus.serviceDisabled => (
        'GPS (dịch vụ vị trí) đang tắt.',
        _BigButton(
          icon: Icons.location_on,
          label: 'Mở cài đặt vị trí',
          tonal: true,
          onPressed: () =>
              ref.read(locationServiceProvider).openLocationSettings(),
        ),
      ),
      LocationStatus.timeout => (
        'Chưa lấy được vị trí trong thời gian cho phép (trong nhà hoặc tín hiệu GPS yếu có thể gây chậm).',
        null as Widget?,
      ),
      _ => ('Không lấy được vị trí do lỗi không xác định.', null as Widget?),
    };
    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_off),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        const SizedBox(height: 16),
        if (extra != null) ...[extra, const SizedBox(height: 12)],
        _BigButton(
          icon: Icons.refresh,
          label: 'Thử lại',
          onPressed: _fetchLocation,
        ),
        const SizedBox(height: 12),
        _BigButton(
          icon: Icons.sms,
          label: 'Bỏ qua, soạn tin không có vị trí',
          tonal: true,
          onPressed: () => _enterPreview(null),
        ),
        const SizedBox(height: 24),
        const Call115Button(),
      ],
    );
  }

  Widget _preview() {
    final loc = _location;
    final message = ref
        .read(prepareSosMessageProvider)
        .call(
          latitude: loc?.latitude,
          longitude: loc?.longitude,
          note: _noteController.text,
          now: _time!,
        );
    final text = Theme.of(context).textTheme;
    return ListView(
      children: [
        Text('Vị trí', style: text.titleMedium),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(loc == null ? Icons.location_off : Icons.location_on),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                loc == null
                    ? 'Không có vị trí'
                    : 'Vĩ độ ${loc.latitude!.toStringAsFixed(6)}, '
                          'kinh độ ${loc.longitude!.toStringAsFixed(6)}'
                          '${loc.accuracyMeters == null ? '' : ' (sai số khoảng ${loc.accuracyMeters!.round()} m)'}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _noteController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Ghi chú (không bắt buộc)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        Text('Nội dung tin nhắn sẽ soạn sẵn', style: text.titleMedium),
        const SizedBox(height: 4),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(message.body, key: const Key('sms_preview')),
          ),
        ),
        if (message.noteTruncated)
          const Text('Ghi chú dài đã được cắt bớt cho vừa tin nhắn.'),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 8),
            Expanded(child: Text(SosScreen.noAutoSendText)),
          ],
        ),
        const SizedBox(height: 16),
        _BigButton(
          icon: Icons.check,
          label: 'Xác nhận và mở tin nhắn',
          onPressed: () => _confirm(message.body),
        ),
        if (_opened) ...[
          const SizedBox(height: 8),
          const Text(
            'Đã mở ứng dụng tin nhắn. Hãy chọn người nhận và tự bấm Gửi.',
          ),
        ],
        const SizedBox(height: 12),
        const Call115Button(),
      ],
    );
  }

  Future<void> _confirm(String body) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref.read(smsComposerProvider).openSmsDraft(body);
    if (!mounted) return;
    if (ok) {
      setState(() => _opened = true);
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Không mở được ứng dụng tin nhắn. Hãy gọi 115.'),
        ),
      );
    }
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tonal = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool tonal;

  @override
  Widget build(BuildContext context) {
    final button = tonal
        ? FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: button,
    );
  }
}
