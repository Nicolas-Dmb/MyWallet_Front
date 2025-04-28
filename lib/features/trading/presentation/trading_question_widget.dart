import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_input_form.dart';
import 'package:mywallet_mobile/features/trading/domain/entities/question_model.dart';

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
            _QuizzButton(text: 'Bourse', onTap: () => {onTap('Stock')}),
            SizedBox(height: 30),
            _QuizzButton(text: 'Crypto', onTap: () => {onTap('Crypto')}),
            SizedBox(height: 30),
            _QuizzButton(text: 'Cash', onTap: () => {onTap('Cash')}),
            SizedBox(height: 30),
            _QuizzButton(text: 'Immo', onTap: () => {onTap('RealEstate')}),
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
  });

  final QuestionModel question;
  final Function setAnswer;

  @override
  Widget build(BuildContext context) {
    if (question.type == 'text') {
      return _StringQuestion(question: question, setAnswer: setAnswer);
    }
    if (question.type == 'integer') {
      return _IntQuestion(question: question, setAnswer: setAnswer);
    }
    if (question.type == 'date') {
      return _DateQuestion(question: question, setAnswer: setAnswer);
    }
    if (question.type == 'choice') {
      return _ChoiceQuestion(question: question, setAnswer: setAnswer);
    }
    if (question.type == 'search') {
      return _SearchQuestion(question: question, setAnswer: setAnswer);
    }
    return Center(
      child: Text(
        "Erreur lors du chargement de la question : \n${question.question}",
        style: AppTextStyles.title2,
      ),
    );
  }
}

class _StringQuestion extends StatefulWidget {
  const _StringQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<StatefulWidget> createState() => _StringQuestionState();
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
  State<StatefulWidget> createState() => _IntQuestionState();
}

class _IntQuestionState extends State<_IntQuestion> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          CustomIntForm(
            labelText: widget.question.defaultValue,
            onChangedValue: (newValue) {
              setState(() {
                value = newValue;
              });
            },
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

class _SearchQuestion extends StatefulWidget {
  const _SearchQuestion({required this.question, required this.setAnswer});

  final QuestionModel question;
  final Function setAnswer;

  @override
  State<StatefulWidget> createState() => _SearchQuestionState();
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
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (
              BuildContext context,
              SearchController controller,
            ) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      value = 'test';
                    });
                  },
                );
              });
            },
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(value),
            text: 'Continuer',
            disable: value == null ? true : false,
          ),
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
  State<StatefulWidget> createState() => _ChoiceQuestionState();
}

class _ChoiceQuestionState extends State<_ChoiceQuestion> {
  String? value;
  int? indexSelected;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.question.answers.length,
            itemBuilder: (BuildContext context, int index) {
              return _SelectedQuizzButton(
                text: widget.question.answers[index],
                onTap: (newValue) {
                  setState(() {
                    value = newValue;
                    indexSelected = index;
                  });
                },
                isSelected: indexSelected == index,
              );
            },
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(value),
            text: 'Continuer',
            disable: value == null ? true : false,
          ),
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
  State<StatefulWidget> createState() => _DateQuestionState();
}

class _DateQuestionState extends State<_DateQuestion> {
  DateTime? value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(widget.question.question, style: AppTextStyles.title2),
          Spacer(),
          InputDatePickerFormField(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime.now(),
            onDateSubmitted: (newValue) {
              setState(() {
                value = newValue;
              });
            },
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          Spacer(flex: 2),
          CustomTextButton(
            onPressed: () => widget.setAnswer(value),
            text: 'Continuer',
            disable: value == null ? true : false,
          ),
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
