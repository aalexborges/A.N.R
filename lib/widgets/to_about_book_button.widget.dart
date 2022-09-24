import 'package:flutter/material.dart';

class ToAboutBookButtonWidget extends StatelessWidget {
  final bool isLoading;
  final String? type;
  final void Function()? onPressed;

  const ToAboutBookButtonWidget({
    this.isLoading = false,
    this.type,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('DETALHES DO ${type?.toUpperCase() ?? 'LIVRO'}'),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: !isLoading
                ? const Icon(Icons.arrow_forward_rounded, size: 20)
                : Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(left: 4),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ],
      ),
    );
  }
}
