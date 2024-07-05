part of '../lodim.dart';

/// A function that returns positions along a line between two points.
typedef Line = Iterable<Pos> Function(Pos start, Pos end, {bool exclusive});

/// Calculates positions along a line optimized for fixed-point math.
///
/// This algorithm calculates the positions along a line between two points
/// using the Bresenham's line algorithm, which rasterizes a line by plotting
/// pixels between two points with no gaps or overlaps.
Iterable<Pos> bresenham(Pos start, Pos end, {bool exclusive = false}) {
  final octant = Octant.from(start, end);
  start = octant.toOctant1(start);
  end = octant.toOctant1(end);

  final delta = end - start;
  final diff = delta.y - delta.x;
  final endX = exclusive ? end.x : end.x + 1;
  return _Bresenham(octant, delta, start, diff, endX);
}

final class _Bresenham extends Iterable<Pos> {
  const _Bresenham(
    this._octant,
    this._delta,
    this._start,
    this._diff,
    this._endX,
  );

  final Octant _octant;
  final Pos _delta;
  final Pos _start;
  final int _diff;
  final int _endX;

  @override
  Iterator<Pos> get iterator {
    return _BresenhamIterator(_octant, _delta, _start, _diff, _endX);
  }
}

class _BresenhamIterator implements Iterator<Pos> {
  _BresenhamIterator(
    this._octant,
    this._delta,
    this._start,
    this._diff,
    this._endX,
  );

  final Octant _octant;
  final Pos _delta;
  final int _endX;

  Pos _start;
  int _diff;

  @override
  Pos get current => _current;
  var _current = Pos.zero;

  @override
  bool moveNext() {
    var Pos(:x, :y) = _start;
    if (x >= _endX) {
      return false;
    }

    _current = _octant.fromOctant1(_start);
    if (_diff >= 0) {
      y += 1;
      _diff -= _delta.x;
    }

    x += 1;
    _diff += _delta.y;
    _start = Pos(x, y);
    return true;
  }
}
