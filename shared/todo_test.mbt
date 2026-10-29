///|
test "the same JSON protocol works across HTTP and IPC" {
  let actions : Array[@shared.Action] = [
    List,
    Add("Learn MoonBit"),
    SetCompleted(42L, true),
    Delete(42L),
  ]
  for action in actions {
    let decoded : @shared.Action = @json.from_json(action.to_json())
    assert_eq(decoded.to_json(), action.to_json())
  }
  let snapshot : @shared.Snapshot = {
    todos: [{ id: 42L, title: "Learn MoonBit", completed: true, }],
  }
  let decoded : @shared.Snapshot = @json.from_json(snapshot.to_json())
  assert_eq(snapshot.todos, decoded.todos)
}
