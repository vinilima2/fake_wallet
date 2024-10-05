// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoryTable extends Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, icon, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String icon;
  final String description;
  const CategoryData(
      {required this.id, required this.icon, required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['icon'] = Variable<String>(icon);
    map['description'] = Variable<String>(description);
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      icon: Value(icon),
      description: Value(description),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      icon: serializer.fromJson<String>(json['icon']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'icon': serializer.toJson<String>(icon),
      'description': serializer.toJson<String>(description),
    };
  }

  CategoryData copyWith({int? id, String? icon, String? description}) =>
      CategoryData(
        id: id ?? this.id,
        icon: icon ?? this.icon,
        description: description ?? this.description,
      );
  CategoryData copyWithCompanion(CategoryCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      icon: data.icon.present ? data.icon.value : this.icon,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('icon: $icon, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, icon, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.icon == this.icon &&
          other.description == this.description);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> icon;
  final Value<String> description;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.icon = const Value.absent(),
    this.description = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String icon,
    required String description,
  })  : icon = Value(icon),
        description = Value(description);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? icon,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (icon != null) 'icon': icon,
      if (description != null) 'description': description,
    });
  }

  CategoryCompanion copyWith(
      {Value<int>? id, Value<String>? icon, Value<String>? description}) {
    return CategoryCompanion(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('icon: $icon, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTable extends Expense with TableInfo<$ExpenseTable, ExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category (id)'));
  static const VerificationMeta _fixedMeta = const VerificationMeta('fixed');
  @override
  late final GeneratedColumn<bool> fixed = GeneratedColumn<bool>(
      'fixed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("fixed" IN (0, 1))'));
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, name, value, category, fixed, expenseDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('fixed')) {
      context.handle(
          _fixedMeta, fixed.isAcceptableOrUnknown(data['fixed']!, _fixedMeta));
    } else if (isInserting) {
      context.missing(_fixedMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!,
      fixed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fixed'])!,
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseTable createAlias(String alias) {
    return $ExpenseTable(attachedDatabase, alias);
  }
}

class ExpenseData extends DataClass implements Insertable<ExpenseData> {
  final int id;
  final String title;
  final String name;
  final double value;
  final int category;
  final bool fixed;
  final DateTime expenseDate;
  final DateTime createdAt;
  const ExpenseData(
      {required this.id,
      required this.title,
      required this.name,
      required this.value,
      required this.category,
      required this.fixed,
      required this.expenseDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<double>(value);
    map['category'] = Variable<int>(category);
    map['fixed'] = Variable<bool>(fixed);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCompanion(
      id: Value(id),
      title: Value(title),
      name: Value(name),
      value: Value(value),
      category: Value(category),
      fixed: Value(fixed),
      expenseDate: Value(expenseDate),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<double>(json['value']),
      category: serializer.fromJson<int>(json['category']),
      fixed: serializer.fromJson<bool>(json['fixed']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<double>(value),
      'category': serializer.toJson<int>(category),
      'fixed': serializer.toJson<bool>(fixed),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseData copyWith(
          {int? id,
          String? title,
          String? name,
          double? value,
          int? category,
          bool? fixed,
          DateTime? expenseDate,
          DateTime? createdAt}) =>
      ExpenseData(
        id: id ?? this.id,
        title: title ?? this.title,
        name: name ?? this.name,
        value: value ?? this.value,
        category: category ?? this.category,
        fixed: fixed ?? this.fixed,
        expenseDate: expenseDate ?? this.expenseDate,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseData copyWithCompanion(ExpenseCompanion data) {
    return ExpenseData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      category: data.category.present ? data.category.value : this.category,
      fixed: data.fixed.present ? data.fixed.value : this.fixed,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('category: $category, ')
          ..write('fixed: $fixed, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, name, value, category, fixed, expenseDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseData &&
          other.id == this.id &&
          other.title == this.title &&
          other.name == this.name &&
          other.value == this.value &&
          other.category == this.category &&
          other.fixed == this.fixed &&
          other.expenseDate == this.expenseDate &&
          other.createdAt == this.createdAt);
}

class ExpenseCompanion extends UpdateCompanion<ExpenseData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> name;
  final Value<double> value;
  final Value<int> category;
  final Value<bool> fixed;
  final Value<DateTime> expenseDate;
  final Value<DateTime> createdAt;
  const ExpenseCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.category = const Value.absent(),
    this.fixed = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpenseCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String name,
    required double value,
    required int category,
    required bool fixed,
    required DateTime expenseDate,
    required DateTime createdAt,
  })  : title = Value(title),
        name = Value(name),
        value = Value(value),
        category = Value(category),
        fixed = Value(fixed),
        expenseDate = Value(expenseDate),
        createdAt = Value(createdAt);
  static Insertable<ExpenseData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? name,
    Expression<double>? value,
    Expression<int>? category,
    Expression<bool>? fixed,
    Expression<DateTime>? expenseDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (category != null) 'category': category,
      if (fixed != null) 'fixed': fixed,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpenseCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? name,
      Value<double>? value,
      Value<int>? category,
      Value<bool>? fixed,
      Value<DateTime>? expenseDate,
      Value<DateTime>? createdAt}) {
    return ExpenseCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      value: value ?? this.value,
      category: category ?? this.category,
      fixed: fixed ?? this.fixed,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (fixed.present) {
      map['fixed'] = Variable<bool>(fixed.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('category: $category, ')
          ..write('fixed: $fixed, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $ExpenseTable expense = $ExpenseTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [category, expense];
}

typedef $$CategoryTableCreateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  required String icon,
  required String description,
});
typedef $$CategoryTableUpdateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  Value<String> icon,
  Value<String> description,
});

final class $$CategoryTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryTable, CategoryData> {
  $$CategoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseTable, List<ExpenseData>>
      _expenseRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.expense,
          aliasName: $_aliasNameGenerator(db.category.id, db.expense.category));

  $$ExpenseTableProcessedTableManager get expenseRefs {
    final manager = $$ExpenseTableTableManager($_db, $_db.expense)
        .filter((f) => f.category.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_expenseRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter expenseRefs(
      ComposableFilter Function($$ExpenseTableFilterComposer f) f) {
    final $$ExpenseTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.expense,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, parentComposers) => $$ExpenseTableFilterComposer(
            ComposerState(
                $state.db, $state.db.expense, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoryTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$CategoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, $$CategoryTableReferences),
    CategoryData,
    PrefetchHooks Function({bool expenseRefs})> {
  $$CategoryTableTableManager(_$AppDatabase db, $CategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoryTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoryTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> description = const Value.absent(),
          }) =>
              CategoryCompanion(
            id: id,
            icon: icon,
            description: description,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String icon,
            required String description,
          }) =>
              CategoryCompanion.insert(
            id: id,
            icon: icon,
            description: description,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CategoryTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({expenseRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expenseRefs) db.expense],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CategoryTableReferences._expenseRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoryTableReferences(db, table, p0)
                                .expenseRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.category == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, $$CategoryTableReferences),
    CategoryData,
    PrefetchHooks Function({bool expenseRefs})>;
typedef $$ExpenseTableCreateCompanionBuilder = ExpenseCompanion Function({
  Value<int> id,
  required String title,
  required String name,
  required double value,
  required int category,
  required bool fixed,
  required DateTime expenseDate,
  required DateTime createdAt,
});
typedef $$ExpenseTableUpdateCompanionBuilder = ExpenseCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> name,
  Value<double> value,
  Value<int> category,
  Value<bool> fixed,
  Value<DateTime> expenseDate,
  Value<DateTime> createdAt,
});

final class $$ExpenseTableReferences
    extends BaseReferences<_$AppDatabase, $ExpenseTable, ExpenseData> {
  $$ExpenseTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTable _categoryTable(_$AppDatabase db) => db.category
      .createAlias($_aliasNameGenerator(db.expense.category, db.category.id));

  $$CategoryTableProcessedTableManager? get category {
    if ($_item.category == null) return null;
    final manager = $$CategoryTableTableManager($_db, $_db.category)
        .filter((f) => f.id($_item.category!));
    final item = $_typedResult.readTableOrNull(_categoryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpenseTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ExpenseTable> {
  $$ExpenseTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get fixed => $state.composableBuilder(
      column: $state.table.fixed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expenseDate => $state.composableBuilder(
      column: $state.table.expenseDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoryTableFilterComposer get category {
    final $$CategoryTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $state.db.category,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableFilterComposer(ComposerState(
                $state.db, $state.db.category, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ExpenseTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ExpenseTable> {
  $$ExpenseTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get fixed => $state.composableBuilder(
      column: $state.table.fixed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expenseDate => $state.composableBuilder(
      column: $state.table.expenseDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoryTableOrderingComposer get category {
    final $$CategoryTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $state.db.category,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableOrderingComposer(ComposerState(
                $state.db, $state.db.category, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ExpenseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseTable,
    ExpenseData,
    $$ExpenseTableFilterComposer,
    $$ExpenseTableOrderingComposer,
    $$ExpenseTableCreateCompanionBuilder,
    $$ExpenseTableUpdateCompanionBuilder,
    (ExpenseData, $$ExpenseTableReferences),
    ExpenseData,
    PrefetchHooks Function({bool category})> {
  $$ExpenseTableTableManager(_$AppDatabase db, $ExpenseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ExpenseTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ExpenseTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<bool> fixed = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpenseCompanion(
            id: id,
            title: title,
            name: name,
            value: value,
            category: category,
            fixed: fixed,
            expenseDate: expenseDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String name,
            required double value,
            required int category,
            required bool fixed,
            required DateTime expenseDate,
            required DateTime createdAt,
          }) =>
              ExpenseCompanion.insert(
            id: id,
            title: title,
            name: name,
            value: value,
            category: category,
            fixed: fixed,
            expenseDate: expenseDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpenseTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({category = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (category) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.category,
                    referencedTable:
                        $$ExpenseTableReferences._categoryTable(db),
                    referencedColumn:
                        $$ExpenseTableReferences._categoryTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpenseTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseTable,
    ExpenseData,
    $$ExpenseTableFilterComposer,
    $$ExpenseTableOrderingComposer,
    $$ExpenseTableCreateCompanionBuilder,
    $$ExpenseTableUpdateCompanionBuilder,
    (ExpenseData, $$ExpenseTableReferences),
    ExpenseData,
    PrefetchHooks Function({bool category})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryTableTableManager get category =>
      $$CategoryTableTableManager(_db, _db.category);
  $$ExpenseTableTableManager get expense =>
      $$ExpenseTableTableManager(_db, _db.expense);
}
