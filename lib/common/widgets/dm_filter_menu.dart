import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class DMFilterMenu extends StatefulWidget {
  final Icon icon;
  final List<MapEntry<int, String>> listOfValuesAndItems;
  final int selectedValue;
  final Function(int) onChanged;

  const DMFilterMenu(
      {Key key,
      this.icon,
      this.listOfValuesAndItems,
      this.selectedValue,
      this.onChanged})
      : assert(icon != null),
        assert(listOfValuesAndItems != null),
        assert(selectedValue != null),
        assert(onChanged != null),
        super(key: key);

  @override
  _DMFilterMenuState createState() => _DMFilterMenuState();
}

class _DMFilterMenuState extends State<DMFilterMenu> {
  GlobalKey _key = LabeledGlobalKey("filterButton");
  OverlayEntry _overlayEntry;
  Size buttonSize;
  Offset buttonPosition;
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: IconButton(
          icon: widget.icon, color: DMColors.white, onPressed: showDropDown),
    );
  }

  void showDropDown() {
    if (isMenuOpen) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  Widget getMenu() {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            List<Widget>.generate(widget.listOfValuesAndItems.length, (index) {
          return InkWell(
            onTap: () {
              closeMenu();
              widget.onChanged(widget.listOfValuesAndItems[index].key);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 15),
                      child: widget.listOfValuesAndItems[index].key ==
                              widget.selectedValue
                          ? Icon(
                              Icons.circle,
                              color: DMColors.primaryBlue,
                              size: 20,
                            )
                          : Icon(
                              Icons.panorama_fish_eye,
                              color: DMColors.grey,
                              size: 20,
                            )),
                  Expanded(
                    child: Text(widget.listOfValuesAndItems[index].value,
                        style: widget.listOfValuesAndItems[index].key ==
                                widget.selectedValue
                            ? DMTypo.bold14PrimaryBlueTextStyle
                            : DMTypo.bold14BlackTextStyle),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: closeMenu,
              child: Stack(
                children: [
                  Positioned(
                    top: buttonPosition.dy + buttonSize.height + 10,
                    left: buttonPosition.dx + buttonSize.width - 200,
                    child:
                        Material(color: Colors.transparent, child: getMenu()),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }
}
