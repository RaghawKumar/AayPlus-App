import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:aay_plus/core/state/app_state_provider.dart';
import 'package:aay_plus/core/logging/dev_log.dart';
import 'marketplace_widgets.dart';

class InspectionMediaScreen extends StatefulWidget {
  final String bookingId, kind;
  final ImagePicker? imagePicker;
  final DateTime? pickupAt;
  const InspectionMediaScreen({
    super.key,
    required this.bookingId,
    required this.kind,
    this.imagePicker,
    this.pickupAt,
  });
  @override
  State<InspectionMediaScreen> createState() => _InspectionMediaScreenState();
}

class _Evidence {
  final XFile file;
  final bool video;
  final Uint8List bytes;
  String? url;
  _Evidence(this.file, this.video, this.bytes);
}

class _InspectionMediaScreenState extends State<InspectionMediaScreen> {
  late final ImagePicker picker = widget.imagePicker ?? ImagePicker();
  final notes = TextEditingController();
  final media = <_Evidence>[];
  bool picking = false, busy = false;
  String? error, progress;
  Timer? clock;
  DateTime? serverPickupAt;
  bool get waitingForPickup =>
      widget.kind == 'pickup' &&
      (serverPickupAt ?? widget.pickupAt)?.isAfter(DateTime.now()) == true;
  @override
  void initState() {
    super.initState();
    DevLog.screen('${widget.kind} inspection media');
    clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && (serverPickupAt ?? widget.pickupAt) != null)
        setState(() {});
    });
  }

  @override
  void dispose() {
    clock?.cancel();
    notes.dispose();
    super.dispose();
  }

  Future<void> pick(ImageSource source, bool video) async {
    if (picking || busy) return;
    FocusScope.of(context).unfocus();
    final count = media.where((m) => m.video == video).length;
    if (count >= (video ? 2 : 12)) {
      setState(
        () => error = video ? 'Add up to two videos.' : 'Add up to 12 photos.',
      );
      return;
    }
    setState(() {
      picking = true;
      error = null;
    });
    DevLog.event('inspection.pick', {'source': source.name, 'video': video});
    try {
      List<XFile> files;
      if (video) {
        final file = await picker.pickVideo(
          source: source,
          maxDuration: const Duration(seconds: 60),
        );
        files = file == null ? [] : [file];
      } else if (source == ImageSource.camera) {
        final file = await picker.pickImage(
          source: source,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
          requestFullMetadata: false,
        );
        files = file == null ? [] : [file];
      } else {
        files = await picker.pickMultiImage(
          limit: 12 - count,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
          requestFullMetadata: false,
        );
      }
      for (final file in files) {
        if (!mounted) return;
        if (await file.length() > (video ? 50 : 8) * 1024 * 1024) {
          if (mounted)
            setState(
              () => error = video
                  ? 'Videos must be smaller than 50 MB.'
                  : 'Photos must be smaller than 8 MB.',
            );
          continue;
        }
        final bytes = await file.readAsBytes();
        if (mounted) setState(() => media.add(_Evidence(file, video, bytes)));
      }
    } on PlatformException catch (e) {
      DevLog.event('inspection.picker.error', {'type': e.code});
      if (mounted)
        setState(
          () =>
              error = e.code.contains('denied') || e.code.contains('restricted')
              ? 'Allow camera, microphone and photo access in your phone settings.'
              : e.code == 'invalid_source'
              ? 'No camera is available. Choose media from your gallery instead.'
              : e.code == 'channel-error'
              ? 'Restart the app with a full native rebuild to enable the media picker.'
              : 'Could not open the media picker. Please try again.',
        );
    } on MissingPluginException {
      if (mounted)
        setState(
          () => error =
              'Stop the app and run flutter run again to load camera and video support.',
        );
    } catch (_) {
      if (mounted)
        setState(
          () => error =
              'Could not read the selected file. Try another photo or video.',
        );
    } finally {
      if (mounted) setState(() => picking = false);
    }
  }

  Future<void> submit() async {
    if (busy || picking) return;
    if (notes.text.trim().isEmpty || media.isEmpty) {
      setState(
        () => error = 'Add condition notes and at least one photo or video.',
      );
      return;
    }
    final state = context.read<AppStateProvider>();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      // Check the authoritative clock/state before uploading any evidence.
      final booking = await state.api.request('/bookings/${widget.bookingId}');
      if (widget.kind == 'pickup' && booking['pickup_available'] == false) {
        if (mounted)
          setState(() {
            serverPickupAt = DateTime.fromMillisecondsSinceEpoch(
              booking['start_at'] * 1000,
            );
            error =
                'Pickup is scheduled for ${DateFormat('d MMM, h:mm a').format(serverPickupAt!)}. Your notes and selected files are kept here. Please wait until pickup opens.';
          });
        return;
      }
      for (var i = 0; i < media.length; i++) {
        if (!mounted) return;
        setState(
          () => progress = 'Uploading evidence ${i + 1} of ${media.length}…',
        );
        final item = media[i];
        item.url ??= await state.api.uploadMedia(
          item.bytes,
          bookingId: widget.bookingId,
          video: item.video,
        );
      }
      if (!mounted) return;
      setState(() => progress = 'Saving inspection…');
      await state.mutate('/bookings/${widget.bookingId}/${widget.kind}', {
        'notes': notes.text.trim(),
        'photos': media.where((m) => !m.video).map((m) => m.url!).toList(),
        'videos': media.where((m) => m.video).map((m) => m.url!).toList(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.kind == 'pickup' ? 'Pickup inspection' : 'Return inspection',
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            FeatureBanner(
              eyebrow: 'Document the handover',
              title: widget.kind == 'pickup'
                  ? 'A clear start.\nA confident rental.'
                  : 'Capture the return.\nClose with confidence.',
              subtitle:
                  'Photograph each side and record a short walkaround. Evidence is visible only to the rental parties and administrators.',
              icon: Icons.video_camera_back_outlined,
            ),
            if (waitingForPickup)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Card(
                  color: warm,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Pickup opens ${DateFormat('d MMM, h:mm a').format((serverPickupAt ?? widget.pickupAt)!)}. You can prepare notes and select evidence now; save becomes available at pickup time.',
                    ),
                  ),
                ),
              ),
            const SectionTitle(
              'Condition notes',
              'Record existing marks, accessories, fuel or battery level.',
            ),
            TextField(
              controller: notes,
              enabled: !busy,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(labelText: 'Inspection notes'),
            ),
            const SectionTitle(
              'Photos & video',
              'Up to 12 photos (8 MB each) and two videos (60 seconds / 50 MB each).',
            ),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                for (final option in [
                  (
                    Icons.photo_library_outlined,
                    'Choose photos',
                    ImageSource.gallery,
                    false,
                  ),
                  (
                    Icons.camera_alt_outlined,
                    'Take photo',
                    ImageSource.camera,
                    false,
                  ),
                  (
                    Icons.video_library_outlined,
                    'Choose video',
                    ImageSource.gallery,
                    true,
                  ),
                  (
                    Icons.videocam_outlined,
                    'Record video',
                    ImageSource.camera,
                    true,
                  ),
                ])
                  OutlinedButton.icon(
                    onPressed: busy || picking
                        ? null
                        : () => pick(option.$3, option.$4),
                    icon: Icon(option.$1, size: 18),
                    label: Text(option.$2),
                  ),
              ],
            ),
            if (picking || busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 20),
            ...media.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 54,
                      height: 54,
                      child: entry.value.video
                          ? const Icon(Icons.video_file_outlined, size: 34)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                entry.value.bytes,
                                fit: BoxFit.cover,
                                errorBuilder: (_, error, stack) =>
                                    const Icon(Icons.image_outlined),
                              ),
                            ),
                    ),
                    title: Text(
                      entry.value.video
                          ? 'Inspection video'
                          : 'Inspection photo',
                    ),
                    subtitle: Text(
                      '${(entry.value.bytes.length / 1024 / 1024).toStringAsFixed(1)} MB · Ready to upload',
                    ),
                    trailing: IconButton(
                      tooltip: 'Remove evidence ${entry.key + 1}',
                      onPressed: busy
                          ? null
                          : () => setState(() => media.removeAt(entry.key)),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            FilledButton(
              onPressed: busy || picking || waitingForPickup ? null : submit,
              child: Text(busy ? progress ?? 'Saving…' : 'Save inspection'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

class EvidenceVideo extends StatefulWidget {
  final String url;
  const EvidenceVideo({super.key, required this.url});
  @override
  State<EvidenceVideo> createState() => _EvidenceVideoState();
}

class _EvidenceVideoState extends State<EvidenceVideo> {
  VideoPlayerController? controller;
  String? error;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final api = context.read<AppStateProvider>().api;
    final player = VideoPlayerController.networkUrl(
      Uri.parse(api.mediaUrl(widget.url)),
      httpHeaders: {
        if (api.token != null) 'Authorization': 'Bearer ${api.token}',
      },
    );
    controller = player;
    try {
      await player.initialize();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted)
        setState(
          () => error = 'Video unavailable. Refresh the booking and try again.',
        );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = controller;
    if (error != null)
      return Padding(padding: const EdgeInsets.all(16), child: Text(error!));
    if (player == null || !player.value.isInitialized)
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    return Column(
      children: [
        AspectRatio(
          aspectRatio: player.value.aspectRatio,
          child: VideoPlayer(player),
        ),
        VideoProgressIndicator(player, allowScrubbing: true),
        IconButton(
          tooltip: player.value.isPlaying ? 'Pause video' : 'Play video',
          onPressed: () {
            setState(() {
              if (player.value.isPlaying) {
                player.pause();
              } else {
                player.play();
              }
            });
          },
          icon: Icon(
            player.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
          ),
        ),
      ],
    );
  }
}
