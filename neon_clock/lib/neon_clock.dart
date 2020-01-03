// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element { background, text }

final _lightTheme = {
  _Element.background: Color.fromRGBO(33, 44, 52, 1),
  _Element.text: Colors.white,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
};

class NeonClock extends StatefulWidget {
  const NeonClock(this.model);

  final ClockModel model;

  @override
  _NeonClockState createState() => _NeonClockState();
}

class _NeonClockState extends State<NeonClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(NeonClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(
      () {
        _dateTime = DateTime.now();

        _timer = Timer(
          Duration(minutes: 1) -
              Duration(seconds: _dateTime.second) -
              Duration(milliseconds: _dateTime.millisecond),
          _updateTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final customSize = MediaQuery.of(context).size.width / 2;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Klaxons',
      shadows: [
        Shadow(
          color: Colors.blue,
          blurRadius: 20,
        ),
        Shadow(
          color: Colors.black.withOpacity(0.5),
          offset: Offset(0.0, 2),
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: colors[_Element.background],
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.15), BlendMode.dstATop),
          image: AssetImage(
            'assets/images/patrick-tomasso-QMDap1TAu0g-unsplash.jpg',
          ),
        ),
      ),
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: FlareActor("assets/flares/dash.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "idle"),
              ),
              BrightnessContainer(
                size: customSize,
                child: Text(hour + ':' + minute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrightnessContainer extends StatelessWidget {
  const BrightnessContainer({
    Key key,
    @required this.size,
    @required this.child,
  }) : super(key: key);
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xdbff).withAlpha(30),
            blurRadius: 90,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: child,
      ),
    );
  }
}
