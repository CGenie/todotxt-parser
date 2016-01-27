// Generated by CoffeeScript 1.10.0
(function() {
  var todo;

  todo = require('../lib/todo');

  exports.testTodoItemValidation = function(test) {
    var item;
    item = new todo.TodoItem({
      description: 'item'
    });
    test.ok(item.validate(), "item is valid");
    test.ok(!item.complete, "item is not complete");
    test.equal(item.priority, null, "item priority not set");
    item = new todo.TodoItem;
    test.ok(!item.validate(), "empty item is not valid");
    return test.done();
  };

  exports.testTodoItemParseSimpleText = function(test) {
    var item;
    item = todo.TodoItem.parse("a");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    item = todo.TodoItem.parse("a\n");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    item = todo.TodoItem.parse("a\nb\n");
    test.equal(item, null, "simple item is not ok");
    return test.done();
  };

  exports.testTodoItemParseWithPriority = function(test) {
    var item;
    item = todo.TodoItem.parse("(A) a");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    test.equal(item.priority, "A");
    item = todo.TodoItem.parse("(a) invalid priority");
    test.ok(item.validate(), "invalid priority item is ok");
    test.equal(item.description, "(a) invalid priority", "item description parsed correctly");
    test.equal(item.priority, null);
    item = todo.TodoItem.parse("(A)->invalid priority");
    test.ok(item.validate(), "invalid priority item is ok");
    test.equal(item.description, "(A)->invalid priority", "item description parsed correctly");
    test.equal(item.priority, null);
    return test.done();
  };

  exports.testTodoItemParseWithProject = function(test) {
    var item;
    item = todo.TodoItem.parse("(A) a +project");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    test.equal(item.priority, "A");
    test.equal(item.project, "project");
    return test.done();
  };

  exports.testTodoItemParseWithContexts = function(test) {
    var item;
    item = todo.TodoItem.parse("(A) a @context1 @context2");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    test.equal(item.priority, "A");
    test.deepEqual(item.contexts, ["context1", "context2"]);
    return test.done();
  };

  exports.testTodoItemParseWithComplete = function(test) {
    var item;
    item = todo.TodoItem.parse("x (A) a @context1 @context2");
    test.ok(item.validate(), "simple item is ok");
    test.equal(item.description, "a", "item description parsed correctly");
    test.equal(item.priority, "A");
    test.deepEqual(item.contexts, ["context1", "context2"]);
    test.ok(item.complete, "item is complete");
    return test.done();
  };

  exports.testTodoItemRender = function(test) {
    var i, item, len, text, texts;
    texts = ["(A) abc @context1 @context2", "abc @context", "(A) abc", "(A) abc +project @context1 @context2", "(A) abc +project"];
    for (i = 0, len = texts.length; i < len; i++) {
      text = texts[i];
      item = todo.TodoItem.parse(text);
      test.equal(text, item.render());
    }
    return test.done();
  };

  exports.testTodoRender = function(test) {
    var text, texts;
    texts = ["(A) abc @context1 @context2", "abc @context", "(A) abc", "(A) abc +project @context1 @context2", "(A) abc +project"];
    text = texts.join('\n');
    test.equals((todo.Todo.parse(text)).render(), text);
    texts = ["(A) abc", "", "(B) def"];
    test.equals((todo.Todo.parse(texts.join('\n'))).render(), ["(A) abc", "(B) def"].join('\n'));
    return test.done();
  };

}).call(this);
