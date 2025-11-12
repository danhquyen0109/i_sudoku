import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:i_sudoku/models/cell.dart';
import 'package:i_sudoku/purchase/purchase_screen.dart';
import 'package:i_sudoku/sudoku_controller.dart';
import 'package:i_sudoku/themes/c_colors.dart';
import 'package:i_sudoku/themes/c_textstyle.dart';
import 'package:i_sudoku/widgets/c_button.dart';
import 'package:i_sudoku/widgets/c_container.dart';
import 'package:i_sudoku/widgets/c_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: CColors.transparent),
      child: GetMaterialApp(
        builder: (context, child) => DefaultTextStyle(
          style: CTextStyles.base,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child ?? const SizedBox(),
          ),
        ),
        theme: ThemeData(
          primaryColor: CColors.primaryA500,
          useMaterial3: false,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final SudokuController controller = Get.put(SudokuController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onCellSelected(null),
      child: Scaffold(
        backgroundColor: CColors.white,
        appBar: AppBar(
          backgroundColor: CColors.white,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: Obx(
            () => CText(
              controller.elapsedText.value,
              style: CTextStyles.base.s24.w600().setColor(CColors.inkA500),
            ),
          ),

          leading: Obx(
            () => Badge(
              label: CText(
                '${controller.availableHints.value}',
                style: CTextStyles.base.s18.w600().setColor(CColors.inkA500),
              ),
              backgroundColor: CColors.greenA100,
              offset: Offset(0, 8),
              child: IconButton(
                padding: EdgeInsets.only(left: 16),
                onPressed: controller.hintTapped,
                icon: Image.asset('assets/icons/light-bulb.png'),
              ),
            ),
          ),

          actions: [
            IconButton(
              onPressed: () => Get.to(() => const PurchaseScreen()),
              icon: Icon(Icons.shopping_cart_rounded, color: CColors.inkA500),
            ),
            SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// board
                GetX(
                  init: controller,
                  builder: (c) => Center(
                    // Aspect ratio will keep the cells as squares
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: LayoutGrid(
                        // Set the cols and rows to be equal sizes
                        columnSizes: List<TrackSize>.generate(
                          9,
                          (index) => 1.fr,
                        ),
                        rowSizes: List<TrackSize>.generate(9, (index) => 1.fr),
                        children: controller.cells.map((cell) {
                          return CContainer(
                            alignment: Alignment.center,
                            color: _cellColor(cell),
                            border: Border(
                              // Conditionally set the border thickness
                              top: BorderSide(
                                color: cell.row! % 3 == 0
                                    ? CColors.inkA600
                                    : CColors.inkA700,
                                width: cell.row! % 3 == 0 ? 1.5 : 0.5,
                              ),
                              bottom: BorderSide(
                                color: CColors.inkA600,
                                width: cell.row! == 8 ? 1.5 : 0,
                              ),
                              left: BorderSide(
                                color: cell.column! % 3 == 0
                                    ? CColors.inkA600
                                    : CColors.inkA700,
                                width: cell.column! % 3 == 0 ? 1.5 : 0.5,
                              ),
                              right: BorderSide(
                                color: CColors.inkA600,
                                width: cell.column! == 8 ? 1.5 : 0,
                              ),
                            ),
                            child: CText(
                              cell.value != -1 ? cell.value?.toString() : '',
                              style: CTextStyles.base.s20.setColor(
                                cell.canEdit == true
                                    ? cell.value != -1 &&
                                              cell.value != cell.solution
                                          ? CColors.redA400
                                          : CColors.primaryA600
                                    : CColors.inkA600,
                              ),
                            ),
                            onTap: () => controller.onCellSelected(cell),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// Number buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<int>.generate(9, (index) => index + 1).map((
                    value,
                  ) {
                    return Expanded(
                      flex: 1,
                      child: CButton.inkwell(
                        height: 50,
                        onTap: () => controller.onFillCell(value),
                        child: CText(
                          value.toString(),
                          style: CTextStyles.base.s32.w500().setColor(
                            CColors.primaryA600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                CButton.base('New Game', onTap: controller.onNewGame),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _cellColor(Cell cell) {
    final currentCol = controller.currentCell.value?.column;
    final currentRow = controller.currentCell.value?.row;
    if (currentCol == null || currentRow == null) {
      if (cell.canEdit == true &&
          cell.value != -1 &&
          cell.value != cell.solution) {
        return CColors.redA300;
      }
      return CColors.white;
    }

    /// Ô được chọn sẽ sáng
    if (controller.currentCell.value == cell) {
      return CColors.active;
    }
    /// Kết quả sai sẽ đỏ
    else if (cell.canEdit == true &&
        cell.value != -1 &&
        cell.value != cell.solution) {
      return CColors.redA300;
    }
    /// Ô cùng hàng, cùng cột sẽ sáng nhẹ hơn
    else if (currentCol == cell.column || currentRow == cell.row) {
      return CColors.subActive;
    }
    /// Ô cùng khối sẽ sáng nhẹ hơn
    else if (currentCol <= 2) {
      if (currentRow <= 2) {
        if (cell.column! <= 2 && cell.row! <= 2) {
          return CColors.subActive;
        }
      } else if (currentRow <= 5) {
        if (cell.column! <= 2 && cell.row! <= 5 && cell.row! > 2) {
          return CColors.subActive;
        }
      } else {
        if (cell.column! <= 2 && cell.row! <= 8 && cell.row! > 5) {
          return CColors.subActive;
        }
      }
    } else if (currentCol <= 5) {
      if (currentRow <= 2) {
        if (cell.column! <= 5 && cell.column! > 2 && cell.row! <= 2) {
          return CColors.subActive;
        }
      } else if (currentRow <= 5) {
        if (cell.column! <= 5 &&
            cell.column! > 2 &&
            cell.row! <= 5 &&
            cell.row! > 2) {
          return CColors.subActive;
        }
      } else {
        if (cell.column! <= 5 &&
            cell.column! > 2 &&
            cell.row! <= 8 &&
            cell.row! > 5) {
          return CColors.subActive;
        }
      }
    } else if (currentCol <= 8) {
      if (currentRow <= 2) {
        if (cell.column! <= 8 && cell.column! > 5 && cell.row! <= 2) {
          return CColors.subActive;
        }
      } else if (currentRow <= 5) {
        if (cell.column! <= 8 &&
            cell.column! > 5 &&
            cell.row! <= 5 &&
            cell.row! > 2) {
          return CColors.subActive;
        }
      } else {
        if (cell.column! <= 8 &&
            cell.column! > 5 &&
            cell.row! <= 8 &&
            cell.row! > 5) {
          return CColors.subActive;
        }
      }
    }
    return CColors.white;
  }
}
