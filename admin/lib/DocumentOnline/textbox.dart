import 'package:flutter/material.dart';

class TextBoxOnlineBuilder extends StatefulWidget {
  const TextBoxOnlineBuilder({
    super.key,
    required this.textBox,
    this.textSizeFactor = 1,
  });

  final Map textBox;
  final double textSizeFactor;

  @override
  State<TextBoxOnlineBuilder> createState() => _TextBoxOnlineBuilderState();
}

class _TextBoxOnlineBuilderState extends State<TextBoxOnlineBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: const silver,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      child: IntrinsicHeight(
        child: Row(
          textDirection: widget.textBox["textalign"] == "left"
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: ParagraphOnline(
                  paragraph: widget.textBox, textSizeFactor: 1.0),
            ),
            Visibility(
              visible: widget.textBox["paragraphIndicator"],
              child: Row(
                textDirection: widget.textBox["textalign"] == "left"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                children: [
                  const SizedBox(width: 4),
                  Container(
                    width: 2,
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          "0xff${widget.textBox['paragraphIndicatorColor']}")),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParagraphOnline extends StatelessWidget {
  const ParagraphOnline(
      {super.key, required this.paragraph, this.textSizeFactor = 1});
  final Map paragraph;
  final double textSizeFactor;
  TextDirection textdirection(String direction) {
    if (direction == "rtl") {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  TextAlign textalign(String align) {
    TextAlign align_ = TextAlign.right;
    if (align == "left") {
      align_ = TextAlign.left;
    }
    if (align == "center") {
      align_ = TextAlign.center;
    }
    return align_;
  }

  FontWeight fontweight(bool bold) {
    return bold ? FontWeight.bold : FontWeight.normal;
  }

  FontStyle fontStyle(bool italic) {
    return italic ? FontStyle.italic : FontStyle.normal;
  }

  TextDecoration textDecoration(String? decoration) {
    TextDecoration textDecoration = TextDecoration.none;
    if (decoration == "underline") {
      textDecoration = TextDecoration.underline;
    }
    if (decoration == "lineThrough") {
      textDecoration = TextDecoration.lineThrough;
    }
    return textDecoration;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        paragraph["text"],
        textDirection: textdirection(paragraph["textdirection"]),
        textAlign: textalign(paragraph["textalign"]),
        style: TextStyle(
          fontWeight: fontweight(paragraph["bold"]),
          fontSize:
              double.parse(paragraph["fontsize"].toString()) * textSizeFactor,
          color: Color(int.parse("0xff${paragraph['textcolor']}")),
          fontFamily: "Shabnam",
          height: 2,
        ),
      ),
    );
  }
}
