todo = require('../lib/todo')


exports.testTodoItemValidation = (test) ->
    item = new todo.TodoItem {description: 'item'}

    test.ok item.validate(), "item is valid"

    item = new todo.TodoItem

    test.ok !item.validate(), "empty item is not valid"

    test.done()


exports.testTodoItemParseSimpleText = (test) ->
    item = todo.TodoItem.parse "a"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"

    item = todo.TodoItem.parse "a\n"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"

    item = todo.TodoItem.parse "a\nb\n"

    test.equal item, null, "simple item is not ok"

    test.done()


exports.testTodoItemParseWithPriority = (test) ->
    item = todo.TodoItem.parse "(A) a"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"
    test.equal item.priority, "A"

    test.done()


exports.testTodoItemParseWithProject = (test) ->
    item = todo.TodoItem.parse "(A) a +project"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"
    test.equal item.priority, "A"
    test.equal item.project, "project"

    test.done()


exports.testTodoItemParseWithContexts = (test) ->
    item = todo.TodoItem.parse "(A) a @context1 @context2"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"
    test.equal item.priority, "A"
    test.deepEqual item.contexts, ["context1", "context2"]

    test.done()


exports.testTodoItemRender = (test) ->
    texts = [
        "(A) abc @context1 @context2",
        "abc @context",
        "(A) abc",
        "(A) abc +project @context1 @context2",
        "(A) abc +project"
    ]

    for text in texts
        item = todo.TodoItem.parse text
        test.equal text, item.render()

    test.done()


exports.testTodoRender = (test) ->
    texts = [
        "(A) abc @context1 @context2",
        "abc @context",
        "(A) abc",
        "(A) abc +project @context1 @context2",
        "(A) abc +project"
    ]
    text = texts.join('\n')

    test.equals (new todo.Todo {items: texts}).render(), text

    test.done()
