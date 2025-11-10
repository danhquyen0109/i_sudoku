class Cell {
  final int? row;
  final int? column;
  final int? value;
  final int? solution;
  final bool? canEdit;

  const Cell({this.row, this.column, this.value, this.canEdit, this.solution});

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      row: int.tryParse(json['row'].toString()),
      column: int.tryParse(json['column'].toString()),
      value: int.tryParse(json['value'].toString()),
      solution: int.tryParse(json['solution'].toString()),
      canEdit: json['canEdit'].toString().contains('true'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (row != null) 'row': row,
    if (column != null) 'column': column,
    if (value != null) 'value': value,
    if (canEdit != null) 'canEdit': canEdit,
    if (solution != null) 'solution': solution,
  };

  Cell copyWith({
    int? row,
    int? column,
    int? value,
    int? solution,
    bool? canEdit,
  }) {
    return Cell(
      row: row ?? this.row,
      column: column ?? this.column,
      value: value ?? this.value,
      canEdit: canEdit ?? this.canEdit,
      solution: solution ?? this.solution,
    );
  }
}
