import 'package:flutter/material.dart';

class Toaster {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(
    BuildContext context, {
    required String message,
    ToasterType type = ToasterType.info,
    Duration duration = const Duration(seconds: 5),
    ToasterPosition position = ToasterPosition.bottom,
  }) {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }

    _overlayEntry = _createOverlayEntry(
      context,
      message: message,
      type: type,
      position: position,
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    Future.delayed(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    });
  }

  static OverlayEntry _createOverlayEntry(
    BuildContext context, {
    required String message,
    required ToasterType type,
    required ToasterPosition position,
  }) {
    return OverlayEntry(
      builder: (context) => _ToasterWidget(
        message: message,
        type: type,
        position: position,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          _isVisible = false;
        },
      ),
    );
  }
}

enum ToasterType {
  success,
  error,
  warning,
  info,
}

enum ToasterPosition {
  top,
  bottom,
  center,
}

class _ToasterWidget extends StatefulWidget {
  final String message;
  final ToasterType type;
  final ToasterPosition position;
  final VoidCallback onDismiss;

  const _ToasterWidget({
    required this.message,
    required this.type,
    required this.position,
    required this.onDismiss,
  });

  @override
  State<_ToasterWidget> createState() => _ToasterWidgetState();
}

class _ToasterWidgetState extends State<_ToasterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: _getSlideBegin(),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  Offset _getSlideBegin() {
    switch (widget.position) {
      case ToasterPosition.top:
        return Offset(0, -1);
      case ToasterPosition.bottom:
        return Offset(0, 1);
      case ToasterPosition.center:
        return Offset(0, 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToasterType.success:
        return Colors.green;
      case ToasterType.error:
        return Colors.red;
      case ToasterType.warning:
        return Colors.orange;
      case ToasterType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToasterType.success:
        return Icons.check_circle;
      case ToasterType.error:
        return Icons.error;
      case ToasterType.warning:
        return Icons.warning;
      case ToasterType.info:
        return Icons.info;
    }
  }

  Alignment _getAlignment() {
    switch (widget.position) {
      case ToasterPosition.top:
        return Alignment.topCenter;
      case ToasterPosition.bottom:
        return Alignment.bottomCenter;
      case ToasterPosition.center:
        return Alignment.center;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.position) {
      case ToasterPosition.top:
        return EdgeInsets.only(top: 50, left: 16, right: 16);
      case ToasterPosition.bottom:
        return EdgeInsets.only(bottom: 50, left: 16, right: 16);
      case ToasterPosition.center:
        return EdgeInsets.symmetric(horizontal: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: _getAlignment(),
        child: Padding(
          padding: _getPadding(),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity!.abs() > 500) {
                      widget.onDismiss();
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIcon(),
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: widget.onDismiss,
                          child: Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}