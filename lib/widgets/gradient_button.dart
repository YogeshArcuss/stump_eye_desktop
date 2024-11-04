import 'package:flutter/material.dart';
import 'package:stump_eye/helpers/app_colors.dart';

class GradientButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isLoading ? 80 : 400, // Adjust the width as needed
      height: 55,
      onEnd: () {},
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.gradient1,
            AppColors.gradient2,
            AppColors.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(
            widget.isLoading ? 27.5 : 27.5), // Fully rounded
      ),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: widget.isLoading
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
      ),
    );
  }
}
