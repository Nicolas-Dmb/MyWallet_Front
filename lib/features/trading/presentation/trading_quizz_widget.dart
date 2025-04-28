import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/core/widgets/components/wallet_snackbar.dart';
import 'package:mywallet_mobile/features/trading/domain/trading_quizz_service.dart';
import 'package:mywallet_mobile/features/trading/presentation/trading_question_widget.dart';
import 'package:mywallet_mobile/features/trading/presentation/trading_quizz_controller.dart';

class TradingQuizzWidget extends StatelessWidget {
  const TradingQuizzWidget({super.key, required this.isBuy});

  final bool isBuy;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TradingQuizzController(di<TradingQuizzService>()),
      child: Scaffold(
        appBar: _AppBar(
          text: isBuy ? 'Achat' : 'Vente',
          back: () => {context.read<TradingQuizzController>().goBack(context)},
          next:
              () => {
                context.read<TradingQuizzController>().setAnswerAndContinue(
                  null,
                ),
              },
        ),
        body: _QuizzManager(isBuy),
      ),
    );
  }
}

class _QuizzManager extends StatelessWidget {
  const _QuizzManager(this.isBuy);

  final bool isBuy;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingQuizzController, TradingQuizzState>(
      builder: (context, state) {
        if (state is Initial) {
          return TradingQuestionWidget(
            onTap:
                (value) => context.read<TradingQuizzController>().loadQuizz(
                  isBuy,
                  value,
                ),
          );
        }
        if (state is Error) {
          walletSnackBar(context, '🚨 Erreur', state.message);
          return state.lastState == null
              ? TradingQuestionWidget(
                onTap:
                    (value) => context.read<TradingQuizzController>().loadQuizz(
                      isBuy,
                      value,
                    ),
              )
              : QuestionManager(
                question:
                    state.lastState!.questions[state
                        .lastState!
                        .currentQuestion],
                setAnswer:
                    (value) => context
                        .read<TradingQuizzController>()
                        .setAnswerAndContinue(value),
              );
        }
        if (state is Success) {
          walletSnackBar(
            context,
            '✅ Sauvegarde',
            'transaction sauvegardée avec succès !',
          );
          context.go('/dashboard');
          return SizedBox.shrink();
        }
        if (state is OnGoingQuizz) {
          return QuestionManager(
            question: state.questions[state.currentQuestion],
            setAnswer:
                (value) => context
                    .read<TradingQuizzController>()
                    .setAnswerAndContinue(value),
          );
        }
        return Center(
          child: CircularProgressIndicator(color: AppColors.border1),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.text, required this.back, required this.next});

  final VoidCallback back;
  final VoidCallback next;

  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background1,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Text(text, style: AppTextStyles.title1),
      ),
      toolbarHeight: 150,
      centerTitle: true,
      leading: SizedBox.shrink(),
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _AppBarButton(text: 'retour', onTap: back),
            _AppBarButton(text: 'passer', onTap: next),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class _AppBarButton extends StatelessWidget {
  const _AppBarButton({required this.onTap, required this.text});
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.transparentButton,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(120),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(120),
          ),
        ),
        child: Center(child: Text(text, style: AppTextStyles.small)),
      ),
    );
  }
}
