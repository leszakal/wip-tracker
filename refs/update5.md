## Sites

Used as reference for using parameters with named routes in go_router: https://dev.to/7twilight/best-practices-for-managing-route-names-and-paths-with-gorouter-in-flutter-4pd8

For passing objects to routes (decided not to use this approach):
https://stackoverflow.com/questions/74741283/go-router-pass-object-to-new-route

## LLM Usage

**-- BEGIN INTERACTION --** 

> My app is tracking projects. There's an option to delete the project from a detailed view page. When I delete a project, I want to return to my home page, which is a list of all projects. I'm having trouble preventing the user from returning to a state where the deleted item can still be interacted with. How would I do this? For some context, I have go_router installed if that has any relevant features.

Great context—this is a common navigation/state issue, and since you're using `go_router`, it can be handled cleanly. The problem is that after deleting the project, the user can hit "back" and return to the now-invalid detail page. To fix this, you want to **pop all routes back to the home page** and **remove the detail page from the stack** after deletion.

---

### ✅ **Option 1: Use `goRouter.go()` to replace navigation stack**

If your home page is at `/projects`, do this after deleting the project:

```dart
context.go('/projects'); // replaces the navigation stack
```

This will navigate to `/projects` and prevent the user from returning to the deleted detail page via back.

---

### ✅ **Option 2: If you're deep in the stack and want to pop back**

You can also pop until you're back to the home route, but **with go_router it's safer and cleaner to use `go()`** for a full route change.

---

### ✅ Bonus: Show confirmation/snackbar

You might want to show a snackbar to confirm deletion:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Project deleted')),
);
context.go('/projects');
```

---

### ❗ If using `pop()` or `Navigator.of(context).pop()`

Avoid using `pop()` after deletion, since that keeps the deleted project's page in the stack. Use `go()` instead to force a clean transition.

---

Would you like help setting up this in a `FutureBuilder` or `onPressed` handler with async deletion logic?

> Will using go() trigger the initState function?

Yes — using `context.go()` **does trigger a full rebuild of the new route**, which includes running `initState()` on the destination page **if**:

- The widget for the route is being newly built (i.e., it's not already in the widget tree),
    
- You’re navigating to a **different** route path (like from `/project/123` to `/projects`),
    
- Your home page (`/projects`) isn't already kept alive via something like an `IndexedStack`.
    

So if your `/projects` route shows a list of projects and uses `initState()` to load or refresh data (e.g., from a database or provider), it **will run again** when you use `context.go('/projects')`.

---

### ✅ To ensure the list is up to date:

Make sure your home page:

- Loads fresh data in `initState()` or via a `FutureBuilder` / `StreamBuilder`, or
    
- Listens to a state management system like `Provider`, `Riverpod`, or `Bloc`.
    

---

### 🔁 Example scenario:

```dart
void _deleteProject(BuildContext context) async {
  await deleteProjectFromDatabase();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Project deleted')),
  );

  context.go('/projects'); // rebuilds and re-triggers initState in /projects
}
```

Would you like help structuring a project list page that reloads when revisited this way?

**-- END INTERACTION --**

**Usage:** Decided to make greater use of go_router over navigator.

___

**-- BEGIN INTERACTION --**

>In flutter, which would be better practice for using go_router to create new page? (1) Passing the object through the route to create the page (using extra) or (2) passing only the an id through path parameters and running a query in initState to create the page?

Great question — both approaches are valid in Flutter with `go_router`, but the best practice depends on **your specific use case**. Here's a comparison to help decide:

---

### ✅ **Option 1: Passing the whole object (via `extra`)**

```dart
GoRouter.of(context).go('/details', extra: myDataObject);
```

#### Pros:

- **Faster page load**: No need to fetch data again if you already have it.
    
- **Less boilerplate**: Avoids querying logic in `initState`.
    
- **Good for in-memory or transient data**: Ideal when the object isn't stored in a database or API.
    

#### Cons:

- **Not deep link friendly**: If a user opens the URL directly (e.g., `/details`), there's no data to deserialize from `extra`.
    
- **Data becomes stale**: If the object changes elsewhere, the passed version may be outdated.
    

---

### ✅ **Option 2: Passing only an ID and fetching in `initState`**

```dart
GoRoute(
  path: '/details/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return DetailPage(id: id);
  },
);
```

#### Pros:

- **Deep link compatible**: The app can reconstruct any page just from the URL.
    
- **Ensures fresh data**: Always fetches latest data from source.
    
- **Better for bookmarking/sharing**: URLs are meaningful and self-contained.
    

#### Cons:

- **Slightly more boilerplate**: You need to handle loading/error states in the page.
    
- **Slower on navigation**: Requires a query even if the data is already available.
    

---

### 🔧 Recommendation:

- **Use `extra` if:**
    
    - You're navigating within the app and already have the object.
        
    - The page doesn't need to support direct deep linking or data persistence across app restarts.
        
- **Use ID + fetch if:**
    
    - You want deep linking or shareable URLs.
        
    - You want the data to be refreshed or you're relying on server/database state.
        

---

### ⚠️ Pro Tip:

You can also **combine both**:

1. Pass `extra` when available (e.g., from a list view).
    
2. Fallback to fetching by ID if `extra` is `null` (e.g., when deep-linked).
    

Would you like a code example of this hybrid approach?

**-- END INTERACTION --**

**Usage:** Decided to try both approaches out. Using extra seemed to cause more delay on opening a new page than just passing the project id. Perhaps it's just due to the slowness of the emulator, but I decided to go with the ID approach for now. Plan to test more once I've an online database running.
