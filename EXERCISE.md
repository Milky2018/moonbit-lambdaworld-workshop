# Exercise: delete a todo across web and desktop

The app already adds and completes todos. Restore deletion by filling in the two
`TODO(exercise-delete)` markers. Use the same frontend and shared SQLite store
for both the web and desktop versions.

## 1. Follow the existing flow

Before editing, follow a completed operation from the view to the database:

```text
frontend/main/view.mbt
  → model.mbt → transport.mbt
    → HTTP → web/main/main.mbt
    → IPC  → desktop/main/main.mbt
      → shared/store/store.mbt → SQLite → Snapshot → frontend
```

Find the `Delete` action in `shared/todo.mbt`. Both backend entry points already
accept this action and pass it to the shared store.

## 2. Complete the two TODOs

- In `frontend/main/view.mbt`, connect each Delete button to the existing message
  and command flow, passing that todo's ID. Keep the `<|` view style.
- In `shared/store/store.mbt`, implement the `Delete` branch with a prepared SQL
  statement, bind the selected ID, execute it, and finalize the statement.
  The existing code below the match returns the updated snapshot.

Deletion must change SQLite data and preserve all other todos. Deleting an ID
that is already absent should leave the database unchanged. The existing web and
desktop entry points need no changes: both call this shared implementation.

## 3. Verify the behavior

The starter code compiles. Its deletion test intentionally fails until the store
TODO is complete; the other tests should pass.

```sh
make check
moon test shared/store --target wasm,native --filter '*delete*'
make test
```

The store test verifies the database operation. To verify the button wiring,
start either web backend with `make web-wasm` or `make web-native`, then:

1. Add two todos and complete one of them.
2. Delete one; verify the other keeps its title and completion state.
3. Refresh, then restart the backend and reload; the deleted todo stays absent.
4. Repeat these steps in `make desktop`.

Use separate runs for the two web targets, which use the same default port.
The web and desktop apps use separate database files by default.

## Discuss

- Which shared code runs in JS, Wasm, and native?
- Why can one SQLite implementation serve both HTTP and IPC requests?
- Why does removing a todo only from the frontend model fail the persistence
  check?

The complete reference implementation is on `main`. Use `git show main:<path>`
to inspect a reference file without switching branches.
