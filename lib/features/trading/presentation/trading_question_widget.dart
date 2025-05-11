import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_input_form.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';
import 'package:mywallet_mobile/features/trading/domain/entities/question_model.dart';
import 'package:mywallet_mobile/features/trading/presentation/trading_quizz_controller.dart';

class TradingQuestionWidget extends StatelessWidget {
  const TradingQuestionWidget({super.key, required this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext build) {
    return Center(
      child: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QuizzButton(text: 'Bourse', onTap: () => {onTap(AssetType.stock)}),
            SizedBox(height: 30),
            _QuizzButton(
              text: 'Crypto',
              onTap: () => {onTap(AssetType.crypto)},
            ),
            SizedBox(height: 30),
            _QuizzButton(text: 'Cash', onTap: () => {onTap(AssetType.cash)}),
            SizedBox(height: 30),
            _QuizzButton(
              text: 'Immo',
              onTap: () => {onTap(AssetType.realEstate)},
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionManager extends StatelessWidget {
  const QuestionManager({
    super.key,
    required this.question,
    required this.setAnswer,
    required this.assetType,
  });

  final QuestionModel question;
  final Function setAnswer;
  final AssetType assetType;

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case 'text':
        return _StringQuestion(question: question, setAnswer: setAnswer);
      case 'integer':
        return _IntQuestion(question: question, setAnswer: setAnswer);
      case 'date':
        return _DateQuestion(question: question, setAnswer: setAnswer);
      case 'choice':
        return _ChoiceQuestion(question: question, setAnswer: setAnswer);
      case 'search':
        return _SearchQuestion(
          question: question,
          setAnswer: setAnswer,
          assetType: assetType,
        );
      default:
        return Center(
          child: Text(
            "Erreur lors du chargement de la question : \n${question.question}",
            style: AppTextStyles.title2,
          ),
        );
    }
  }
}

class _StringQuestion extends StatefulWidget {
  const _StringQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<_StringQuestion> createState() => _StringQuestionState();
}

class _StringQuestionState extends State<_StringQuestion> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          CustomTextForm(
            focus: true,
            onChangedValue: (newValue) {
              setState(() {
                value = newValue;
              });
            },
            labelText: widget.question.defaultValue,
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(value),
            text: 'Continuer',
            disable: value == null ? true : false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _IntQuestion extends StatefulWidget {
  const _IntQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<_IntQuestion> createState() => _IntQuestionState();
}

class _IntQuestionState extends State<_IntQuestion> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.answer ?? '');
  }

  @override
  void didUpdateWidget(covariant _IntQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      setState(() {
        _controller = TextEditingController(text: widget.question.answer ?? '');
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          CustomIntForm(
            focus: true,
            controller: _controller,
            labelText: widget.question.defaultValue,
            onChangedValue: (newValue) {
              setState(() {});
            },
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () async => widget.setAnswer(_controller.text),
            text: 'Continuer',
            disable: _controller.text.isEmpty ? true : false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _SearchQuestion extends StatefulWidget {
  const _SearchQuestion({
    required this.question,
    required this.setAnswer,
    required this.assetType,
  });

  final QuestionModel question;
  final Function setAnswer;
  final AssetType assetType;

  @override
  State<_SearchQuestion> createState() => _SearchQuestionState();
}

class _SearchQuestionState extends State<_SearchQuestion> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          FakeSearchBarWidget(
            onPress: (selectedValue) => {value = selectedValue},
            filter:
                widget.assetType == AssetType.stock
                    ? AssetFilterType.bourse
                    : AssetFilterType.crypto,
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(value),
            text: 'Continuer',
            disable: value == null ? true : false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _ChoiceQuestion extends StatefulWidget {
  const _ChoiceQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<_ChoiceQuestion> createState() => _ChoiceQuestionState();
}

class _ChoiceQuestionState extends State<_ChoiceQuestion> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.answer ?? '');
  }

  @override
  void didUpdateWidget(covariant _ChoiceQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      setState(() {
        for (var answer in widget.question.answers) {
          if (answer == widget.question.answer) {
            _controller = TextEditingController(
              text: widget.question.answer ?? '',
            );
            return;
          }
        }
        _controller = TextEditingController();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: widget.question.answers.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SelectedQuizzButton(
                    text: widget.question.answers[index],
                    onTap: (newValue) {
                      setState(() {
                        _controller.text = widget.question.answers[index];
                      });
                    },
                    isSelected:
                        _controller.text == widget.question.answers[index],
                  ),
                );
              },
            ),
          ),
          Spacer(),
          CustomTextButton(
            onPressed: () => widget.setAnswer(_controller.text),
            text: 'Continuer',
            disable: _controller.text.isEmpty ? true : false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _DateQuestion extends StatefulWidget {
  const _DateQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<_DateQuestion> createState() => _DateQuestionState();
}

class _DateQuestionState extends State<_DateQuestion> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.answer ?? '');
  }

  @override
  void didUpdateWidget(covariant _DateQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      setState(() {
        _controller = TextEditingController(text: widget.question.answer ?? '');
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.transparentButton,
              onPrimary: AppColors.text2,
              onSurface: AppColors.text1,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(textStyle: AppTextStyles.text),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          TextField(
            controller: _controller,
            readOnly: true,
            style: AppTextStyles.text,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.interactive1, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.border3, width: 3),
              ),
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
            ),
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(_controller.text),
            text: 'Continuer',
            disable: _controller.text.isEmpty ? true : false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _QuizzButton extends StatelessWidget {
  const _QuizzButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.button1,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(child: Text(text, style: AppTextStyles.title2)),
      ),
    );
  }
}

class _SelectedQuizzButton extends StatelessWidget {
  const _SelectedQuizzButton({
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  final String text;
  final Function onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.button1 : AppColors.transparentButton,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(child: Text(text, style: AppTextStyles.title2)),
      ),
    );
  }
}
