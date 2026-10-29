///|
test "create, complete, and delete with parameter binding" {
  let store = @store.Store::open(":memory:")
  defer store.close()
  assert_eq(store.execute(List).todos.length(), 0)
  let added = store.execute(Add("  Learn 'MoonBit'; DROP TABLE todos; --  "))
  assert_eq(added.todos.length(), 1)
  let todo = added.todos[0]
  assert_eq(todo.title, "Learn 'MoonBit'; DROP TABLE todos; --")
  assert_false(todo.completed)
  let completed = store.execute(SetCompleted(todo.id, true))
  assert_true(completed.todos[0].completed)
  let reopened = store.execute(SetCompleted(todo.id, false))
  assert_false(reopened.todos[0].completed)
  assert_eq(store.execute(Delete(todo.id)).todos.length(), 0)
  let next = store.execute(Add("Next lesson")).todos[0]
  assert_true(next.id > todo.id)
}

///|
test "reject an empty title without changing stored data" {
  let store = @store.Store::open(":memory:")
  defer store.close()
  store.execute(Add("Keep me")) |> ignore
  try store.execute(Add(" \t\n ")) catch {
    @store.EmptyTitle => ()
    error => raise error
  } noraise {
    _ => fail("expected EmptyTitle")
  }
  assert_eq(store.execute(List).todos.length(), 1)
}
