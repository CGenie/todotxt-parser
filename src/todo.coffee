class TodoItem
    constructor: (params) ->
        @priority = params?.priority
        @creationDate = params?.creationDate
        @description = params?.description
        @dueDate = params?.dueDate
        @project = params?.project
        @contexts = params?.contexts || []

    render: () ->
        ret = ""
        if this.priority
            ret += "(#{this.priority}) "
        # TODO: creationDate
        ret += this.description
        # TODO: dueDate
        if this.dueDate or this.project or this.contexts.length > 0
            ret += " "
        if this.project
            ret += "+#{this.project}"
            if this.contexts.length > 0
                ret += " "
        ret += ("@#{context}" for context in this.contexts).join " "

        ret

    validate: () ->
        if !this.description
            return false

        return true

    this.parse = (text) ->
        # Parses only single-line texts, no newlines inside text
        text ?= ''
        text = text.trim()

        if '\n' in text
            return null

        priorityRe = /\([ABC]\)/
        priority = text.match(priorityRe)?[0]
        if priority
            priority = priority[1]
        description = text.replace(priorityRe, '').trim()

        contextRe = /\@\w+/g
        contexts = (c[1..] for c in (text.match(contextRe) || []))
        description = description.replace(contextRe, '').trim()

        projectRe = /\+\w+/
        project = text.match(projectRe)?[0]
        if project
            project = project[1..]
        description = description.replace(projectRe, '').trim()

        return new TodoItem
            priority: priority
            description: description
            project: project
            contexts: contexts


class Todo
    constructor: (params) ->
        @items = (TodoItem.parse text for text in (params?.items || []))

    render: () ->
        (item.render() for item in this.items).join "\n"


exports.TodoItem = TodoItem
exports.Todo = Todo
