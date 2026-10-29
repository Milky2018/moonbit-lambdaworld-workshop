///|
using @html {button, div, form, h1, input, li, p, span, ul}

///|
fn view(model : Model, emit : @rabbita.Emit[Msg]) -> @html.Html {
  div(class="todo-app") <| [
    h1 <| "TodoList",
    form(on_submit=emit(Add)) <| [
      input(
        id="title",
        value=model.draft,
        placeholder="What needs doing?",
        attrs=@html.Attrs::build().aria_label("New todo").disabled(model.busy),
        on_input=emit.map(value => DraftChanged(value)),
      ),
      button(type_="submit", disabled=model.busy || model.draft.trim() == "") <| "Add",
    ],
    p(attrs=@html.Attrs::build().role("status")) <| (if model.busy {
      "Saving / loading…"
    } else {
      model.error
    }),
    button(disabled=model.busy, on_click=emit(Run(List))) <| "Refresh",
    ul <| [
      for todo in model.todos => {
        li <| [
          button(
            disabled=model.busy,
            attrs=@html.Attrs::build()
              .aria_label("Toggle " + todo.title)
              .aria_pressed(todo.completed.to_string()),
            on_click=emit(Run(SetCompleted(todo.id, !todo.completed))),
          ) <| (if todo.completed { "✓" } else { "○" }),
          span(class=if todo.completed { "completed" } else { "" }) <| todo.title,
          button(disabled=model.busy, on_click=emit(Run(Delete(todo.id)))) <| "Delete",
        ]
      }
    ],
  ]
}
