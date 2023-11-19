import 'package:admin/Constants/colors.dart';
import 'package:admin/Document/DocumentModel.dart';
import 'package:admin/iconsax_icons.dart';
import 'package:flutter/material.dart';

class ParagraphEditor extends StatefulWidget {
  ParagraphEditor({
    super.key,
    required this.document,
    this.textBox,
    this.textBoxIndex,
  });
  final DocumentModel document;
  final Map? textBox;
  final int? textBoxIndex;
  @override
  State<ParagraphEditor> createState() => _ParagraphEditorState();
}

class _ParagraphEditorState extends State<ParagraphEditor>
    with SingleTickerProviderStateMixin {
  final TextEditingController text = TextEditingController();
  Map textBox = {
    "type": "textbox",
    "id": "",
    "noteable": false,
    "noted": false,
    "enableLink": false,
    "link": "",
    // -------------------------------------
    "textdirection": "rtl",
    "textalign": "right",
    "paragraphIndicator": false,
    "paragraphIndicatorColor": "4BCB81",
    "fontsize": 16.0,
    "bold": false,
    "textcolor": "252525",
    // -------------------------------------
    "text": "",
  };
  // -------------------------------------------------------------------------------------
  List fontSizes = ["10", "12", "14", "16", "18", "20", "22", "24"];
  List colors = [
    "252525", // black Main Text Color
    "0074D9", //blue
    "FFDC00", //yellow
    "2ECC40", //green
    "F012BE", // pink
    "FF4136", //red
    "B10DC9", // purple
  ];

  void save() {
    textBox["text"] = text.text;
    if (text.text.isNotEmpty) {
      if (widget.textBox != null && widget.textBoxIndex != null) {
        widget.document.body[widget.textBoxIndex!] = textBox;
        widget.document.save();
      } else {
        DateTime now = DateTime.now();
        String id =
            "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}";
        textBox["id"] = id;
        widget.document.body.add(textBox);
        widget.document.save();
      }
    }
  }

  @override
  void initState() {
    if (widget.textBox != null && widget.textBoxIndex != null) {
      textBox = Map.of(widget.textBox!);
      text.text = widget.textBox!["text"];
    }

    super.initState();
  }

  Widget toolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PopupMenuButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  shadowColor: Colors.white,
                  elevation: 2,
                  position: PopupMenuPosition.under,
                  offset: const Offset(-100, 14),
                  constraints:
                      const BoxConstraints(maxWidth: 400, minWidth: 400),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<Object>>[
                      PopupMenuItem(
                        onTap: null,
                        enabled: false,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...fontSizes.map((e) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: InkWell(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: silver,
                                      ),
                                      child: Center(
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              color: black, fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      setState(() {
                                        textBox["fontsize"] = double.parse(e);
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: silver,
                    ),
                    child: Center(
                      child: Text(
                        textBox["fontsize"].toString(),
                        style: TextStyle(color: black, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["bold"]
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.format_bold_rounded,
                        color: textBox["bold"] ? Colors.white : gray,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["bold"] = !textBox["bold"];
                    });
                  },
                ),
                PopupMenuButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  shadowColor: Colors.white,
                  elevation: 2,
                  position: PopupMenuPosition.under,
                  offset: const Offset(-100, 10),
                  constraints:
                      const BoxConstraints(maxWidth: 400, minWidth: 400),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<Object>>[
                      PopupMenuItem(
                        onTap: null,
                        enabled: false,
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...colors.map((e) {
                                return InkWell(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(int.parse("0xff$e")),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      textBox['textcolor'] = e;
                                    });
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Icon(
                      Icons.format_color_text_rounded,
                      size: 20,
                      color: Color(int.parse("0xff${textBox['textcolor']}")),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["textalign"] == "left"
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.format_align_left_rounded,
                        color: textBox["textalign"] == "left"
                            ? Colors.white
                            : gray,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["textalign"] = "left";
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["textalign"] == "center"
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.format_align_center_rounded,
                        color: textBox["textalign"] == "center"
                            ? Colors.white
                            : gray,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["textalign"] = "center";
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["textalign"] == "right"
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.format_align_right_rounded,
                        color: textBox["textalign"] == "right"
                            ? Colors.white
                            : gray,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["textalign"] = "right";
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["textdirection"] == "rtl"
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Text(
                        "FA",
                        style: TextStyle(
                          color: textBox["textdirection"] == "rtl"
                              ? Colors.white
                              : gray,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["textdirection"] = "rtl";
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: textBox["textdirection"] == "ltr"
                          ? const Color(0xff4BCB81)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Text(
                        "EN",
                        style: TextStyle(
                          color: textBox["textdirection"] == "ltr"
                              ? Colors.white
                              : gray,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      textBox["textdirection"] = "ltr";
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  InkWell(
                    child: Icon(Iconsax.link),
                    onTap: textBox["enableLink"]
                        ? () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: this.context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: LinkAddress(textBox: textBox),
                                  );
                                });
                          }
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        activeColor: const Color(0xff4BCB81),
                        value: textBox["enableLink"],
                        onChanged: (value) {
                          setState(() {
                            textBox["enableLink"] = value;
                            textBox["noteable"] = false;
                          });
                        },
                      ),
                      const Text(
                        "لینک",
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  PopupMenuButton(
                    enabled: textBox["paragraphIndicator"],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    shadowColor: Colors.white,
                    elevation: 2,
                    position: PopupMenuPosition.under,
                    offset: const Offset(-100, 10),
                    constraints:
                        const BoxConstraints(maxWidth: 400, minWidth: 400),
                    itemBuilder: (context) {
                      return <PopupMenuEntry<Object>>[
                        PopupMenuItem(
                          onTap: null,
                          enabled: false,
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...colors.map((e) {
                                  return InkWell(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse("0xff$e")),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      setState(() {
                                        textBox['paragraphIndicatorColor'] = e;
                                      });
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Icon(
                        Iconsax.align_right,
                        size: 20,
                        color: textBox["paragraphIndicator"]
                            ? Color(int.parse(
                                "0xff${textBox['paragraphIndicatorColor']}"))
                            : lightgray,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        activeColor: const Color(0xff4BCB81),
                        value: textBox["paragraphIndicator"],
                        onChanged: (value) {
                          setState(() {
                            textBox["paragraphIndicator"] = value;
                          });
                        },
                      ),
                      const Text(
                        "نشانگر پاراگراف",
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    activeColor: const Color(0xff4BCB81),
                    value: textBox["noteable"],
                    onChanged: (value) {
                      setState(() {
                        textBox["noteable"] = value;
                        textBox["enableLink"] = false;
                      });
                    },
                  ),
                  const Text(
                    "ذخیره سازی",
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // paragraph =
    //     TextBoxPreviewBuilder(textBox: buildParagraph(), textSizeFactor: 1);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
              forceElevated: true,
              leading: IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                  )),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4BCB81),
                          // shape: const CircleBorder(side: BorderSide.none),
                          elevation: 0,
                        ),
                        onPressed: () {
                          save();
                          Navigator.of(context).pop();
                        },
                        child: const Text("ذخیره"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: toolbar()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: IntrinsicHeight(
                      child: Row(
                        textDirection: textBox["textalign"] == "left"
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              controller: text,
                              textDirection: textBox["textdirection"] == "rtl"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              maxLines: null,
                              expands: true,
                              // minLines: 2,
                              textAlign: textBox["textalign"] == "right"
                                  ? TextAlign.right
                                  : textBox["textalign"] == "left"
                                      ? TextAlign.left
                                      : TextAlign.center,
                              style: TextStyle(
                                height: 1.5,
                                color: Color(
                                    int.parse("0xff${textBox['textcolor']}")),
                                fontWeight: textBox["bold"]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: double.parse(
                                    textBox["fontsize"].toString()),
                              ),

                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                hintText: "متن خود را بنویسید",
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: TextStyle(
                                  color: Color(
                                      int.parse("0xff${textBox['textcolor']}")),
                                  fontSize: double.parse(
                                      textBox["fontsize"].toString()),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: textBox["paragraphIndicator"],
                            child: Row(
                              // textDirection: textBox["textdirection"] == "left"
                              //     ? TextDirection.rtl
                              //     : TextDirection.ltr,
                              children: [
                                const SizedBox(width: 6),
                                Container(
                                  width: 2,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        "0xff${textBox['paragraphIndicatorColor']}")),
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

class LinkAddress extends StatefulWidget {
  LinkAddress({
    super.key,
    required this.textBox,
  });
  final Map textBox;
  @override
  State<LinkAddress> createState() => _LinkAddressState();
}

class _LinkAddressState extends State<LinkAddress> {
  TextEditingController link = TextEditingController();
  FocusNode fNode = FocusNode();
  bool validName = false;
  String? errorText;

  List<String> titles = [];
  @override
  void initState() {
    link.text = widget.textBox["link"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7DABF6),
                      shape: const CircleBorder(side: BorderSide.none),
                    ),
                    onPressed: validName
                        ? () {
                            widget.textBox["link"] = link.text;
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 40,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(int.parse("0xff${theme['boldcolor']}")),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: Border.all(color: lightgray),
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: link,
                      textDirection: TextDirection.rtl,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        hintText: "نام برچسب",
                        labelStyle: TextStyle(
                            color: fNode.hasFocus ? Colors.blue : Colors.white,
                            fontSize: 15),
                      ),
                      onChanged: (value) {
                        setState(() {
                          errorText = error(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // documentColor(),
          errorText != null
              ? Text(errorText!, textDirection: TextDirection.rtl)
              : Container()
        ],
      ),
    );
  }

  String? error(String name) {
    if (name.isEmpty) {
      validName = false;
      return null;
    } else {
      if (!titles.contains(name.replaceAll(" ", ""))) {
        validName = true;
        return null;
      } else {
        validName = false;
        return "این زیر گروه وحود دارد!";
      }
    }
  }
}
