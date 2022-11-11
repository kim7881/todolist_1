import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todolist_1/models/todo_model.dart';

import 'todo_filter.dart';
import 'todo_list.dart';
import 'todo_search.dart';

class FilteredTodoState extends Equatable {
  final List<Todo> filteredTodos;

  FilteredTodoState({
    required this.filteredTodos,
  });

  factory FilteredTodoState.initial() {
    return FilteredTodoState(filteredTodos: []);
  }

  @override
  List<Object?> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodoState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodoState(
        filteredTodos: filteredTodos ?? this.filteredTodos);
  }
}

class FilteredTodos with ChangeNotifier {
  FilteredTodoState _state = FilteredTodoState.initial();
  FilteredTodoState get state => _state;

  void update(
    TodoFilter todoFilter,
    TodoSearch todoSearch,
    TodoList todoList,
  ) {
    List<Todo> _filteredTodos;

    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoList.state.todos;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(
      filteredTodos: _filteredTodos
    );
    notifyListeners();
  }
}
