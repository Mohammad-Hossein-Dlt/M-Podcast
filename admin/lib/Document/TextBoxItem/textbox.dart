import 'package:admin/Constants/colors.dart';
import 'package:admin/Document/DocumentModel.dart';
import 'package:admin/Document/TextBoxItem/paragraph_editor.dart';
import 'package:flutter/material.dart';

class TextBoxBuilder extends StatefulWidget {
  TextBoxBuilder({
    super.key,
    required this.document,
    required this.textBox,
    required this.textBoxIndex,
    this.textSizeFactor = 1,
    required this.clickable,
    required this.reload,
  });
  final DocumentModel document;
  final Map textBox;
  final int textBoxIndex;
  final double textSizeFactor;
  final bool clickable;
  final Function reload;

  @override
  State<TextBoxBuilder> createState() => _TextBoxBuilderState();
}

class _TextBoxBuilderState extends State<TextBoxBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: midWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          textDirection: widget.textBox["textalign"] == "left"
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            Expanded(
              child: clickableParagraph(context, widget.textBox),
            ),
            Visibility(
              visible: widget.textBox["paragraphIndicator"],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  textDirection: widget.textBox["textalign"] == "left"
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    const SizedBox(width: 6),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget clickableParagraph(BuildContext context, Map paragraph) {
    return InkWell(
      onTap: widget.clickable
          ? () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => ParagraphEditor(
                    document: widget.document,
                    textBox: widget.textBox,
                    textBoxIndex: widget.textBoxIndex,
                  ),
                ),
              )
                  .then((value) {
                widget.reload();
              });
            }
          : null,
      child: Paragraph(paragraph: widget.textBox, textSizeFactor: 1),
    );
  }
}

class Paragraph extends StatelessWidget {
  Paragraph({super.key, required this.paragraph, this.textSizeFactor = 1});
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
