import 'dart:collection';

import 'package:superpower/superpower.dart';
import 'package:test/test.dart';

import 'common_list_iterable.dart';

$Iterable<int> get empty => $Iterable<int>.empty();

$Iterable<E> $it<E>(List<E> elements) => $Iterable(elements).toIterable();

void main() {
  test("test new Iterable", () {
    var list = $Iterable(List<int>());
    expect(list is $List, true);

    var iterable = $Iterable(Iterable<int>.empty());
    expect(iterable is $List, false);
  });

  test("test lastIndex", () {
    var iteratable = $Iterable<int>.generate(10);
    expect(iteratable.lastIndex, 9);
  });

  test("test first second third fourth", () {
    var elements = $it([1, 2, 3, 4, 5]);
    {
      var result = elements.first;
      expect(result, 1);
    }
    {
      var result = elements.second;
      expect(result, 2);
    }
    {
      var result = elements.third;
      expect(result, 3);
    }
    {
      var result = elements.fourth;
      expect(result, 4);
    }
  });

  test("test elementAtOrNull", () {
    var elements = $it([0, 1, 2, 3]);
    expect(elements.elementAtOrNull(2), 2);
    expect(elements.elementAtOrNull(4), null);

    expect(empty.elementAtOrNull(1), null);
    expect(empty.elementAtOrNull(0), null);
  });

  test("test elementAtOrElse", () {
    testElementAtOrElse(empty, $it([0, 1, 2, 3]));
  });

  test("test firstOrNull lastOrNull", () {
    var elements = $it([0, 1, 2, 3]);
    expect(elements.firstOrNull, 0);
    expect(empty.firstOrNull, null);

    expect(elements.lastOrNull, 3);
    expect(empty.lastOrNull, null);
  });

  test("test firstOrElse lastOrElse", () {
    var elements = $it([0, 1, 2, 3]);
    expect(elements.firstOrElse(-1), 0);
    expect(empty.firstOrElse(-1), -1);

    expect(elements.lastOrElse(-1), 3);
    expect(empty.lastOrElse(-1), -1);
  });

  test("test firstOrNullWhere lastOrNullWhere", () {
    var elements =
        $it(['t', 'th', 'thi', 'this', 'is', 'a', 't', 'te', 'tes', 'test']);
    expect(elements.firstOrNullWhere((it) => it.startsWith('t')), 't');
    expect(elements.firstOrNullWhere((it) => it.startsWith('tes')), 'tes');
    expect(empty.firstOrNullWhere((it) => true), null);

    expect(elements.lastOrNullWhere((it) => it.startsWith('th')), 'this');
    expect(elements.lastOrNullWhere((it) => it.startsWith('t')), 'test');
    expect(empty.lastOrNullWhere((it) => true), null);
  });

  test("test none", () {
    var elements = $it([0, 1, 2, 3]);
    expect(elements.none((it) => it > 4), true);
    expect(elements.none((it) => it > 1), false);
  });

  test("test drop", () {
    testDrop(empty, $it([0, 1, 2, 3, 4, 5, 6]));
  });

  test("test dropWhile", () {
    var elements = $it([0, 1, 2, 3, 4, 5, 6]);
    {
      var result = elements.dropWhile((_) => false);
      expect(result, elements);
    }
    {
      var result = elements.dropWhile((it) => it < 4);
      expect(result, [4, 5, 6]);
    }
    {
      var result = elements.dropWhile((_) => true);
      expect(result, <int>[]);
    }
  });

  test("test slice", () {
    var elements = $it<int>([0, 1, 2, 3, 4, 5, 6]);
    {
      var result = empty.slice(3, 2, true);
      expect(result, empty);
    }
    {
      var result = empty.slice(-1, 2, true);
      expect(result, empty);
    }
    {
      var result = empty.slice(-1, -2, true);
      expect(result, empty);
    }
    {
      var result = elements.slice(0);
      expect(result, elements);
    }
    {
      var result = elements.slice(4);
      expect(result, [4, 5, 6]);
    }
    {
      var result = elements.slice(4, 6);
      expect(result, [4, 5, 6]);
    }
    {
      var result = elements.slice(2, 5);
      expect(result, [2, 3, 4, 5]);
    }
    {
      var result = elements.slice(-1);
      expect(result, [6]);
    }
    {
      var result = elements.slice(-4);
      expect(result, [3, 4, 5, 6]);
    }
    {
      var result = elements.slice(-4, 5);
      expect(result, [3, 4, 5]);
    }
    {
      var result = elements.slice(-4, 3);
      expect(result, [3]);
    }
    {
      var result = elements.slice(-5, -2);
      expect(result, [2, 3, 4, 5]);
    }
    {
      var result = elements.slice(-5, -5);
      expect(result, [2]);
    }
    {
      var result = elements.slice(3, -2);
      expect(result, [3, 4, 5]);
    }
    {
      var result = elements.slice(3, -4);
      expect(result, [3]);
    }
    {
      expect(() => empty.slice(0), throwsRangeError);
      expect(() => empty.slice(0, 2), throwsRangeError);
      expect(() => empty.slice(-1), throwsRangeError);
      expect(() => empty.slice(0, -5), throwsRangeError);
      expect(() => elements.slice(7), throwsRangeError);
      expect(() => elements.slice(-8), throwsRangeError);
      expect(() => elements.slice(0, 7), throwsRangeError);
      expect(() => elements.slice(-2, 4), throwsRangeError);
      expect(() => elements.slice(-2, 4, true), throwsRangeError);
      expect(() => elements.slice(3, 1), throwsRangeError);
      expect(() => elements.slice(3, 1, true), throwsRangeError);
    }
    {
      var result = elements.slice(0, 7, true);
      expect(result, elements);
    }
  });

  test("test forEachIndexed", () {
    var elements = $it([6, 5, 4, 3, 2, 1, 0]);
    var index = 0;
    elements.forEachIndexed((it, i) {
      expect(it, 6 - index);
      expect(i, index);
      index++;
    });
  });

  test("test whereIndexed", () {
    var elements = $it([6, 5, 4, 3, 2, 1, 0]);
    var index = 0;
    var result = elements.whereIndexed((it, i) {
      expect(it, 6 - index);
      expect(i, index);
      index++;
      return i > 3;
    });
    expect(result, [2, 1, 0]);
  });

  test("test whereNotNull", () {
    var elements = $it([0, null, 1, null, null, 2]);
    var result = elements.whereNotNull;
    expect(result, [0, 1, 2]);
  });

  test("test contentEquals", () {
    var elements1 = $it(['test', 'test', 'tom', 'true']);
    var elements2 = $it(['test', 't', 'te', 'tes']);
    var elements3 = $it([0, 1, 2, 3, 4, 5]);
    var elements4 = $it([0, 1, 2, 3, 4, 5, 6]);
    {
      var elementsList = elements1.toList();
      var result = elements1.contentEquals(elementsList);
      expect(elements1 == elementsList, false);
      expect(result, true);
    }
    {
      var result = elements1.contentEquals(elements2);
      expect(result, false);
    }
    {
      var result = elements1.contentEquals(elements2, (e1, e2) {
        return e1.codeUnitAt(0) == e2.codeUnitAt(0);
      });
      expect(result, true);
    }
    {
      var result = elements3.contentEquals(elements4);
      expect(result, false);
    }
    {
      var result = elements4.contentEquals(elements3);
      expect(result, false);
    }
  });

  test("test sorted sortedDescending", () {
    var elements1 = $([6, 3, 2, 4, 5, 1, 0]);
    {
      var result = empty.sorted();
      expect(result, empty);
    }
    {
      var result = elements1.sorted();
      expect(result, [0, 1, 2, 3, 4, 5, 6]);
    }
    {
      var result = empty.sortedDescending();
      expect(result, empty);
    }
    {
      var result = elements1.sortedDescending();
      expect(result, [6, 5, 4, 3, 2, 1, 0]);
    }
  });

  test("test sortedBy sortedWith sortedByDescending", () {
    var elements1 = $(['this', 'is', 'a', 'teest']);
    var expected = $(['a', 'is', 'this', 'teest']);
    {
      var result = empty.sortedBy((it) => 1);
      expect(result, empty);
    }
    {
      var result = elements1.sortedBy((it) => it.length);
      expect(result, expected);
    }
    {
      var result = empty.sortedWith((a, b) => 0);
      expect(result, empty);
    }
    {
      var result = elements1.sortedWith((a, b) => a.length.compareTo(b.length));
      expect(result, expected);
    }
    {
      var result = empty.sortedByDescending((it) => 1);
      expect(result, empty);
    }
    {
      var result = elements1.sortedByDescending((it) => it.length);
      expect(result, expected.reversed);
    }
  });

  test("test thenBy thenWith thenByDescending", () {
    var elements1 = $(['aaa', 'bb', 'a', 'cc', 'bbbb', 'aa', 'cccc']);
    var expected = $(['a', 'aa', 'aaa', 'bb', 'bbbb', 'cc', 'cccc']);
    var nothing = (dynamic it) => 0;
    var firstChar = (String it) => it.codeUnitAt(0);
    var length = (String it) => it.length;
    {
      var result = empty.sortedBy(nothing).thenBy(nothing);
      expect(result, empty);
    }
    {
      var result = elements1.sortedBy(firstChar).thenBy(length);
      expect(result, expected);
    }
    {
      var result = empty.sortedBy(nothing).thenWith((a, b) => 0);
      expect(result, empty);
    }
    {
      var result = elements1
          .sortedBy(firstChar)
          .thenWith((a, b) => a.length.compareTo(b.length));
      expect(result, expected);
    }
    {
      var result = empty.sortedBy(nothing).thenByDescending(nothing);
      expect(result, empty);
    }
    {
      var result =
          elements1.sortedByDescending(firstChar).thenByDescending(length);
      expect(result, expected.reversed);
    }
  });

  test("test sum", () {
    var elements1 = $it([1, 2, 3, 4, 5]);
    var elements2 = $it([1, 2, 0, 3, 4, null, 5, 6, null, 9]);
    {
      var result = empty.sum();
      expect(result, 0);
    }
    {
      var result = elements1.sum();
      expect(result, 15);
    }
    {
      var result = elements2.sum();
      expect(result, 30);
    }
  });

  test("test sumBy", () {
    var elements1 = $it(['t', 'te', 'tes', 'test', 'hello']);
    var elements2 = $it([
      't',
      'te',
      '',
      'tes',
      'test',
      null,
      'hello',
      'hello6',
      null,
      'hello6789'
    ]);
    {
      var result = empty.sumBy((it) => 0.0);
      expect(result, 0);
    }
    {
      var result = elements1.sumBy((it) => it?.length);
      expect(result, 15);
    }
    {
      var result = elements2.sumBy((it) => it?.length);
      expect(result, 30);
    }
  });

  test("test average", () {
    var elements1 = $it([1, 2, 3, 4, 5]);
    var elements2 = $it([1, 2, 0, 3, 4, null, 5, 6, null, 9]);
    {
      var result = empty.average();
      expect(result, null);
    }
    {
      var result = elements1.average();
      expect(result, 3.0);
    }
    {
      var result = elements2.average();
      expect(result, 3.0);
    }
  });

  test("test averageBy", () {
    var elements1 = $it(['t', 'te', 'tes', 'test', 'hello']);
    var elements2 = $it([
      't',
      'te',
      '',
      'tes',
      'test',
      null,
      'hello',
      'hello6',
      null,
      'hello6789'
    ]);
    {
      var result = empty.averageBy((it) => 0.0);
      expect(result, null);
    }
    {
      var result = elements1.averageBy((it) => it?.length);
      expect(result, 3.0);
    }
    {
      var result = elements2.averageBy((it) => it?.length);
      expect(result, 3.0);
    }
  });

  test("test min max", () {
    var elements1 = $it([3]);
    var elements2 = $it([0, 1, 2, 3, 4, 5, 6]);
    {
      var result = empty.min();
      expect(result, null);
    }
    {
      var result = elements1.min();
      expect(result, 3);
    }
    {
      var result = elements2.min();
      expect(result, 0);
    }
    {
      var result = empty.max();
      expect(result, null);
    }
    {
      var result = elements1.max();
      expect(result, 3);
    }
    {
      var result = elements2.max();
      expect(result, 6);
    }
  });

  test("test minBy maxBy", () {
    var elements1 = $it(['test']);
    var elements2 = $it(['t', 'te', 'tes', 'test', 'hello']);
    {
      var result = empty.minBy((it) => 0);
      expect(result, null);
    }
    {
      var result = elements1.minBy((it) => it.length);
      expect(result, 'test');
    }
    {
      var result = elements2.minBy((it) => it.length);
      expect(result, 't');
    }
    {
      var result = empty.maxBy((it) => 0);
      expect(result, null);
    }
    {
      var result = elements1.maxBy((it) => it.length);
      expect(result, 'test');
    }
    {
      var result = elements2.maxBy((it) => it.length);
      expect(result, 'hello');
    }
  });

  test("test minWith maxWith", () {
    var elements1 = $it(['abc']);
    var elements2 = $it(['xd', 'qb', 'mc', 'pa', 're']);
    {
      var result = empty.minWith((e1, e2) => 0);
      expect(result, null);
    }
    {
      var result = elements1.minWith((e1, e2) {
        return e1.codeUnitAt(1).compareTo(e2.codeUnitAt(1));
      });
      expect(result, 'abc');
    }
    {
      var result = elements2.minWith((e1, e2) {
        return e1.codeUnitAt(1).compareTo(e2.codeUnitAt(1));
      });
      expect(result, 'pa');
    }
    {
      var result = empty.maxWith((e1, e2) => 0);
      expect(result, null);
    }
    {
      var result = elements1.maxWith((e1, e2) {
        return e1.codeUnitAt(1).compareTo(e2.codeUnitAt(1));
      });
      expect(result, 'abc');
    }
    {
      var result = elements2.maxWith((e1, e2) {
        return e1.codeUnitAt(1).compareTo(e2.codeUnitAt(1));
      });
      expect(result, 're');
    }
  });

  test("test count", () {
    var elements = $it(['', 't', 'te', '', 'tes', 'test', 'hi', 'hello']);
    {
      var result = empty.count();
      expect(result, 0);
    }
    {
      var result = empty.count((it) => true);
      expect(result, 0);
    }
    {
      var result = elements.count((it) => it.length > 2);
      expect(result, 3);
    }
  });

  test("test reverse", () {
    var elements = $it(['', 't', 'te', '', 'tes', 'test', 'hi', 'hello']);
    {
      var result = empty.reverse();
      expect(result, empty);
    }
    {
      var result = elements.reverse();
      expect(result, elements.toList().reversed);
    }
  });

  test("test distinct", () {
    var elements =
        $it(['h', 'hi', 'h', 'test', 'hi', 'test', 'hi', 'h', 'hello']);
    {
      var result = empty.distinct();
      expect(result, empty);
    }
    {
      var result = elements.distinct();
      expect(result, ['h', 'hi', 'test', 'hello']);
    }
  });

  test("test distinctBy", () {
    var elements =
        $it(['oh', 'hi', 'oh', 'test1', 'hi', 'test1', 'hi', 'hello']);
    {
      var result = empty.distinctBy((it) => 1);
      expect(result, empty);
    }
    {
      var result = elements.distinctBy((it) => it.length);
      expect(result, ['oh', 'test1']);
    }
  });

  test("test chunked", () {
    var elements = $Iterable.generate(50, (i) => i);
    {
      expect(() => elements.chunked(0), throwsArgumentError);
    }
    {
      var result = empty.chunked(1);
      expect(result, <List<int>>[]);
    }
    {
      var result = elements.chunked(1).toList();
      var expected = elements.map((it) => [it]);
      expect(result, expected);
    }
    {
      var result = elements.chunked(10).toList();
      expect(result.length, 5);
      expect(result[3], [30, 31, 32, 33, 34, 35, 36, 37, 38, 39]);
    }
    {
      var result = elements.chunked(11).toList();
      expect(result.length, 5);
      expect(result[4], [44, 45, 46, 47, 48, 49]);
    }
    {
      var result = elements.chunked(60).toList();
      expect(result, [elements]);
    }
  });

  test("test flatMap", () {
    var elements = $it([0, 1, 2]);
    {
      var result = empty.flatMap((it) => <int>[]);
      expect(result, empty);
    }
    {
      var result = elements.flatMap((it) => [it, it, it]);
      expect(result, [0, 0, 0, 1, 1, 1, 2, 2, 2]);
    }
  });

  test("test flatten", () {
    var elements = $it([
      [0, 0, 0],
      [1, 1, 1],
      [2, 2, 2]
    ]);
    {
      var result = empty.flatten();
      expect(result, empty);
    }
    {
      var result = elements.flatten();
      expect(result, [0, 0, 0, 1, 1, 1, 2, 2, 2]);
    }
  });

  test("test cycle", () {
    var elements = $it([0, 1, 2]);
    {
      var result = empty.cycle();
      expect(result.elementAt(0), null);
      expect(result.elementAt(10), null);
      expect(result.elementAt(40), null);
    }
    {
      var result = elements.cycle();
      expect(result.elementAt(0), 0);
      expect(result.elementAt(1), 1);
      expect(result.elementAt(2), 2);
      expect(result.elementAt(3), 0);
      expect(result.elementAt(4), 1);
      expect(result.elementAt(5), 2);
      expect(result.elementAt(30), 0);
      expect(result.elementAt(31), 1);
      expect(result.elementAt(32), 2);
    }
  });

  test("test intersect", () {
    var elements1 = $it([3, 4, 5]);
    var elements2 = $it([0, 1, 2, 3, 4, 5, 6]);
    var elements3 = $it([4, 10, 20]);
    {
      var result = empty.intersect(empty);
      expect(result, empty);
    }
    {
      var result = empty.intersect(elements1);
      expect(result, empty);
    }
    {
      var result = elements1.intersect(empty);
      expect(result, empty);
    }
    {
      var result = elements1.intersect(elements2);
      expect(result, elements1);
    }
    {
      var result = elements2.intersect(elements1);
      expect(result, elements1);
    }
    {
      var result = elements1.intersect(elements3);
      expect(result, [4]);
    }
  });

  test("test except", () {
    var elements1 = $it([3, 4, 5]);
    var elements2 = $it([0, 1, 2, 3, 4, 5, 6]);
    {
      var result = empty.except(empty);
      expect(result, empty);
    }
    {
      var result = elements1.except(empty);
      expect(result, elements1);
    }
    {
      var result = elements2.except(elements1);
      expect(result, [0, 1, 2, 6]);
    }
    {
      var result = elements1.except(elements2);
      expect(result, empty);
    }
  });

  test("test exceptElement", () {
    var elements = $it([0, 1, 2]);
    {
      var result = empty.exceptElement(5);
      expect(result, empty);
    }
    {
      var result = elements.exceptElement(1);
      expect(result, [0, 2]);
    }
    {
      var result = elements.exceptElement(4);
      expect(result, elements);
    }
  });

  test("test prepend", () {
    var elements1 = $it([0, 1, 2]);
    var elements2 = $it([3, 4, 5]);
    {
      var result = empty.prepend(empty);
      expect(result, empty);
    }
    {
      var result = empty.prepend(empty);
      expect(result, empty);
    }
    {
      var result = empty.prepend(elements1);
      expect(result, elements1);
    }
    {
      var result = elements1.prepend(empty);
      expect(result, elements1);
    }
    {
      var result = elements1.prepend(elements2);
      expect(result, [3, 4, 5, 0, 1, 2]);
    }
    {
      var result = elements2.prepend(elements1);
      expect(result, [0, 1, 2, 3, 4, 5]);
    }
  });

  test("test append", () {
    var elements1 = $it([0, 1, 2]);
    var elements2 = $it([3, 4, 5]);
    {
      var result = empty.append(empty);
      expect(result, empty);
    }
    {
      var result = empty.append(empty);
      expect(result, empty);
    }
    {
      var result = empty.append(elements1);
      expect(result, elements1);
    }
    {
      var result = elements1.append(empty);
      expect(result, elements1);
    }
    {
      var result = elements1.append(elements2);
      expect(result, [0, 1, 2, 3, 4, 5]);
    }
    {
      var result = elements2.append(elements1);
      expect(result, [3, 4, 5, 0, 1, 2]);
    }
  });

  test("test prependElement", () {
    var elements = $it([3, 4, 5]);
    {
      var result = empty.prependElement(2);
      expect(result, [2]);
    }
    {
      var result = elements.prependElement(2);
      expect(result, [2, 3, 4, 5]);
    }
  });

  test("test appendElement", () {
    var elements = $it([3, 4, 5]);
    {
      var result = empty.appendElement(6);
      expect(result, [6]);
    }
    {
      var result = elements.appendElement(6);
      expect(result, [3, 4, 5, 6]);
    }
  });

  test("test union", () {
    var elements1 = $it([3, 4, 5]);
    var elements2 = $it([0, 1, 2, 3, 4, 5, 6]);
    var elements3 = $it([4, 10, 20]);
    {
      var result = empty.union(empty);
      expect(result, empty);
    }
    {
      var result = empty.union(elements1);
      expect(result, elements1);
    }
    {
      var result = elements1.union(empty);
      expect(result, elements1);
    }
    {
      var result = elements1.union(elements2);
      expect(result, [3, 4, 5, 0, 1, 2, 6]);
    }
    {
      var result = elements2.union(elements1);
      expect(result, elements2);
    }
    {
      var result = elements1.union(elements3);
      expect(result, [3, 4, 5, 10, 20]);
    }
  });

  test("test zip", () {
    var elements1 = $it([1, 2, 3]);
    var elements2 = $it([2, 4, 6]);
    {
      var result = empty.zip(empty, (e1, e2) => null);
      expect(result, empty);
    }
    {
      var result = elements1.zip(elements2, (e1, e2) => e1 / e2);
      expect(result, [0.5, 0.5, 0.5]);
    }
    {
      var result = elements2.zip(elements1, (e1, e2) => e1 / e2);
      expect(result, [2.0, 2.0, 2.0]);
    }
  });

  test("test toIterable", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.toIterable();
      expect(result, empty);
    }
    {
      var result = elements.toIterable();
      expect(result == elements, false);
      expect(result, elements);
    }
  });

  test("test toLazyList", () {
    {
      var result = empty.toLazyList();
      expect(result, empty);
    }
    {
      var accessed = false;
      var elements = $Iterable<int>.generate(10, (index) {
        accessed = true;
        return index;
      });
      var result = elements.toLazyList();
      expect(accessed, false);
      expect(result.second, 1);
      expect(accessed, true);
    }
  });

  test("test toSet", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.toSet();
      expect(result, Set<int>());
    }
    {
      var result = elements.toSet();
      expect(result, Set<int>.from(elements));
    }
  });

  test("test toHashSet", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.toHashSet();
      expect(result, HashSet<int>());
    }
    {
      var result = elements.toHashSet();
      expect(result, HashSet<int>.from(elements));
    }
  });

  test("test toUnmodifiable", () {
    var result = $([1, 2, 3]).toUnmodifiable();
    expect(() => result[0] = 2, throwsUnsupportedError);
    expect(() => result.length = 4, throwsUnsupportedError);
    expect(() => result.clear(), throwsUnsupportedError);
  });

  test("test associate", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.associate((it) => MapEntry(0, 0));
      expect(result, Map<int, int>());
    }
    {
      var result = elements.associate((it) => MapEntry(it.toString(), it));
      expect(result['1'], 1);
      expect(result['2'], 2);
      expect(result['3'], 3);
    }
  });

  test("test associateBy", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.associateBy((it) => 0);
      expect(result, Map<int, int>());
    }
    {
      var result = elements.associateBy((it) => it.toString());
      expect(result['1'], 1);
      expect(result['2'], 2);
      expect(result['3'], 3);
    }
  });

  test("test associateWith", () {
    var elements = $it([1, 2, 3]);
    {
      var result = empty.associateWith((it) => 0);
      expect(result, Map<int, int>());
    }
    {
      var result = elements.associateWith((it) => it.toString());
      expect(result[1], '1');
      expect(result[2], '2');
      expect(result[3], '3');
    }
  });

  test("test partition", () {
    var elements = $it([1, 2, 3, 4, 5, 6]);
    {
      var result = empty.partition((it) => false);
      expect(result, <List<int>>[[], []]);
    }
    {
      var result = elements.partition((it) => it % 2 == 1);
      expect(result, [
        [1, 3, 5],
        [2, 4, 6]
      ]);
    }
  });
}