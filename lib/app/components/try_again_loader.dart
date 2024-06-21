import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/skeleton.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TryAgainLoader extends StatefulWidget {
  const TryAgainLoader({
    super.key,
    this.onRetry,
    this.skeletonCount = 5,
    required this.child,
    required this.isLoading,
    required this.isData,
    required this.failure,
  });
  final Function()? onRetry;
  final bool isLoading;
  final Failure? failure;
  final bool isData;
  final int skeletonCount;
  final Widget child;
  @override
  State<TryAgainLoader> createState() => _TryAgainLoaderState();
}

class _TryAgainLoaderState extends State<TryAgainLoader> {
  @override
  Widget build(BuildContext context) {
    final aspect = MediaQuery.of(context).size.shortestSide;
    final loadState = widget.isLoading
        ? LoadState.loading
        : widget.isData
            ? LoadState.done
            : LoadState.error;
    return switch (loadState) {
      LoadState.loading => Column(
          children: List.filled(
            widget.skeletonCount,
            const Skeleton(
              height: 50,
            ),
          ),
        ),
      LoadState.done => widget.child,
      LoadState.error => Column(
          children: [
            20.getHightSizedBox,
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LottieBuilder.asset(
                getLottie,
                width: aspect / 3,
              ),
            ),
            const Text("حدث شيء غير متوقع!\nالرجاء إعادة المحاولة لاحقاً"),
            Text(
              widget.failure?.message ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).hintColor),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextButton(
                text: "إعادة المحاولة",
                onPressed: widget.onRetry,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
    };
  }

  String get getLottie {
    if (widget.failure is OfflineFailure) {
      return "assets/animations/no_internet.json";
    } else {
      return "assets/animations/server_error.json";
    }
  }
}

enum LoadState { loading, done, error }
