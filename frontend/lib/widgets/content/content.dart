import 'package:flutter/material.dart';
import 'dart:async';
import '../tts/tts.dart';

class AdvancedParagraphReadingWidget extends StatefulWidget {
  final List<String> paragraphs;
  final Color readColor;
  final Color unreadColor;
  final double paragraphSpacing;

  const AdvancedParagraphReadingWidget({
    Key? key,
    required this.paragraphs,
    this.readColor = Colors.black,
    this.unreadColor = Colors.grey,
    this.paragraphSpacing = 16.0,
  }) : super(key: key);

  @override
  State<AdvancedParagraphReadingWidget> createState() =>
      _AdvancedParagraphReadingWidgetState();
}

class _AdvancedParagraphReadingWidgetState
    extends State<AdvancedParagraphReadingWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentReadIndex = 0;
  final List<GlobalKey> _paragraphKeys = [];

  // 添加新的狀態變量
  bool _isAutoPlaying = false;
  Timer? _autoPlayTimer;
  // 添加新的控制變量
  bool _ignoreScroll = false;
  bool _Playing = false;
  @override
  void initState() {
    super.initState();
    // 為每個段落創建一個key
    _paragraphKeys.addAll(
        List.generate(widget.paragraphs.length, (index) => GlobalKey()));

    // 監聽滾動事件
    _scrollController.addListener(_onScroll);

    // Initialize TTS once and set initial text
    TtsService.init();
    TtsService.setCompletionHandler(_onTtsComplete);
  }

  void _onScroll() {
    // Remove this entire method as we don't want scroll position to control paragraphs
  }

  // 添加自動播放控制方法
  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;

      if (_isAutoPlaying) {
        // 如果是在最後一段，則重置到第一段
        if (_currentReadIndex >= widget.paragraphs.length - 1) {
          _ignoreScroll = true; // 設置忽略滾動
          _currentReadIndex = 0;
          _scrollController
              .animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          )
              .then((_) {
            setState(() {
              _ignoreScroll = false;
            });
            _startAutoPlay();
          });
        } else {
          _startAutoPlay();
        }
      } else {
        _stopAutoPlay();
      }
    });
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (_currentReadIndex == 0 && !_Playing) {
      _Playing = true;
      TtsService.setText(widget.paragraphs[_currentReadIndex]);
    }
    // Just play the current paragraph since text is already set
    TtsService.play();
  }

  // Add new method for TTS playback
  void _playCurrentParagraph() {
    if (_currentReadIndex >= widget.paragraphs.length) {
      _stopAutoPlay();
      return;
    }

    TtsService.play();
    _scrollToParagraph(_currentReadIndex);
  }

  // Add TTS completion handler
  void _onTtsComplete() {
    if (_isAutoPlaying && _currentReadIndex < widget.paragraphs.length - 1) {
      setState(() {
        _Playing = false;
        _currentReadIndex++;
        // Set text for next paragraph after completion
        TtsService.setText(widget.paragraphs[_currentReadIndex]);
      });
      _playCurrentParagraph();
    } else {
      _stopAutoPlay();
    }
  }

  // Add new helper method to handle scrolling
  void _scrollToParagraph(int index) {
    final currentKey = _paragraphKeys[index];
    final RenderBox? renderBox =
        currentKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final viewportHeight = _scrollController.position.viewportDimension;
      final maxScroll = _scrollController.position.maxScrollExtent;

      double targetScroll =
          _scrollController.offset + position.dy - (viewportHeight / 2);
      targetScroll = targetScroll.clamp(0, maxScroll);

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _stopAutoPlay() {
    TtsService.pause();
    setState(() {
      _isAutoPlaying = false;
    });
  }

  @override
  void dispose() {
    TtsService.stop();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 修改控制按鈕
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _toggleAutoPlay,
              icon: Icon(_isAutoPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(
                _isAutoPlaying ? '暫停' : '自動播放',
                style: const TextStyle(
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.paragraphs.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: widget.paragraphSpacing),
                  child: Text(
                    widget.paragraphs[index],
                    key: _paragraphKeys[index],
                    style: TextStyle(
                      color: index == _currentReadIndex
                          ? widget.readColor
                          : widget.unreadColor,
                      fontSize: 16,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
