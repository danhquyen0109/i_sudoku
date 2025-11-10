import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_sudoku/models/cell.dart';
import 'package:sudoku_dart/sudoku_dart.dart';
import 'dart:async';

class SudokuController extends GetxController {
  late RxList<Cell> cells;
  final currentCell = Rx<Cell?>(null);
  // Timer / thời gian giải
  final elapsed = Duration.zero.obs; // cập nhật mỗi giây để UI bind
  final elapsedText = '00:00'.obs; // formatted text để hiển thị
  Timer? _timer;
  DateTime? _startTime;
  late Sudoku sudokuBoard;
  final boardData = List.generate(
    9,
    (row) => List.generate(9, (col) => Cell(row: row, column: col)),
  );

  @override
  void onInit() {
    super.onInit();
    cells = boardData.expand((e) => e).toList().obs;
    onNewGame();
  }

  void onCellSelected(Cell? cell) {
    currentCell.value = cell;
  }

  void onNewGame() {
    sudokuBoard = Sudoku.generate(Level.easy);

    /// clear
    cells.assignAll(
      cells
          .map((e) => e.copyWith(value: null, canEdit: true, solution: -1))
          .toList(),
    );

    /// assign new value
    cells.assignAll(
      cells
          .map(
            (e) => e.copyWith(
              value: sudokuBoard.puzzle[cells.indexOf(e)],
              canEdit: sudokuBoard.puzzle[cells.indexOf(e)] == -1,
              solution: sudokuBoard.solution[cells.indexOf(e)],
            ),
          )
          .toList(),
    );

    // reset và start timer cho ván mới
    _resetTimer();
    _startTimer();
  }

  void onFillCell(int value) {
    if (currentCell.value?.canEdit == true) {
      currentCell.value = currentCell.value?.copyWith(value: value);

      /// update board
      final int index = cells.indexWhere(
        (p0) =>
            p0.column == currentCell.value?.column &&
            p0.row == currentCell.value?.row,
      );
      cells[index] = cells[index].copyWith(value: value);

      update();
      _maybeValidateBoard();
    }
  }

  void hintTapped() {
    final cell = currentCell.value;
    if (cell == null) return;
    if (cell.canEdit != true) return;
    final sol = cell.solution;
    if (sol == -1) return;

    // điền giá trị lời giải vào ô hiện tại và khóa ô (không cho edit tiếp)
    currentCell.value = cell.copyWith(value: sol, canEdit: false);

    final int index = cells.indexWhere(
      (p0) => p0.column == cell.column && p0.row == cell.row,
    );
    if (index != -1) {
      cells[index] = cells[index].copyWith(value: sol, canEdit: false);
    }

    update();
    _maybeValidateBoard();
  }

  /// Kiểm tra khi bàn đã được điền đầy đủ.
  void _maybeValidateBoard() {
    // Nếu còn ô chưa điền (null hoặc -1) => chưa hoàn tất
    if (cells.any((c) => c.value == null || c.value == -1)) return;

    // Nếu đầy đủ thì so sánh với lời giải
    if (_checkSolution()) {
      // dừng timer khi hoàn thành rồi hiển thị thời gian
      _stopTimer();
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Congratulations!'),
          content: Text(
            'You have completed the puzzle!\nTime: ${elapsedText.value}',
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // đóng dialog
                onNewGame();
              },
              child: const Text('New Game'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  bool _checkSolution() {
    for (final c in cells) {
      final v = c.value;
      // Nếu còn ô chưa điền (null hoặc -1) => chưa hoàn tất
      if (v == null || v == -1) return false;
      // Nếu giá trị khác lời giải => sai
      if (v != c.solution) return false;
    }
    return true;
  }

  // ---------- Timer helpers ----------
  void _startTimer() {
    _stopTimer();
    _startTime = DateTime.now();
    // initial values
    elapsed.value = Duration.zero;
    elapsedText.value = _formatDuration(elapsed.value);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = now.difference(_startTime ?? now);
      elapsed.value = diff;
      elapsedText.value = _formatDuration(diff);
      update(); // notify UI if needed
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    _stopTimer();
    _startTime = null;
    elapsed.value = Duration.zero;
    elapsedText.value = _formatDuration(Duration.zero);
    update();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    if (hours > 0) {
      final hh = hours.toString().padLeft(2, '0');
      return '$hh:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
