todo = require('../lib/todo')


exports.testTodoItemValidation = (test) ->
    item = new todo.TodoItem {description: 'item'}

    test.ok item.validate(), "item is valid"
    test.ok !item.complete, "item is not complete"
    test.equal item.priority, null, "item priority not set"

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

    item = todo.TodoItem.parse "(Z) z"
    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "z", "item description parsed correctly"
    test.equal item.priority, "Z"

    item = todo.TodoItem.parse "(a) invalid priority"
    test.ok item.validate(), "invalid priority item is ok"
    test.equal item.description, "(a) invalid priority", "item description parsed correctly"
    test.equal item.priority, null

    item = todo.TodoItem.parse "(A)->invalid priority"
    test.ok item.validate(), "invalid priority item is ok"
    test.equal item.description, "(A)->invalid priority", "item description parsed correctly"
    test.equal item.priority, null

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


exports.testTodoItemParseWithComplete = (test) ->
    item = todo.TodoItem.parse "x (A) a @context1 @context2"

    test.ok item.validate(), "simple item is ok"
    test.equal item.description, "a", "item description parsed correctly"
    test.equal item.priority, "A"
    test.deepEqual item.contexts, ["context1", "context2"]
    test.ok item.complete, "item is complete"

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

    test.equals (todo.Todo.parse text).render(), text

    # filter out invalid items
    texts = [
        "(A) abc",
        "",
        "(B) def"
    ]

    test.equals (todo.Todo.parse(texts.join('\n'))).render(), [
        "(A) abc",
        "(B) def"
    ].join('\n')

    test.done()
