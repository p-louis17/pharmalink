# PharmaLink — Getting started

## 1. Clone and install

```bash
git clone <repo-url>
cd pharmalink
flutter pub get
```

## 2. Get the Google Maps API key from Louis

You'll need it to run the app locally. Don't put it in code or commit it — pass it in at run time:

```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=the_key_here
```

If you're using VS Code, add it to `.vscode/launch.json` instead so you don't retype it every time (ask Louis for the snippet).

## 3. Project structure

```
lib/
├── main.dart / app.dart          # app entry point — don't touch unless we agree on it together
├── core/                         # shared stuff: theme, constants, shared services/widgets
├── navigation/root_shell.dart    # bottom nav — owns the 4 tabs below
└── features/
    ├── ralph_home/               ← Ralph        (bottom nav: Home)
    ├── faith_search_detail/      ← Faith        (bottom nav: Search)
    ├── louis_map/                ← Louis        (bottom nav: Map)
    ├── raquel_profile/           ← Raquel       (bottom nav: Profile)
    └── blessing_pharmacy_detail/ ← Blessing     (NOT a tab — a detail screen
                                                    pushed from Home/Search/Map
                                                    when a pharmacy is tapped)
```

**Rule of thumb:** work inside your own `features/<yourname_feature>/` folder (`cubit/`, `models/`, `screens/`, `widgets/`). Only touch `core/` or `navigation/` if it's something genuinely shared — flag it in the group chat first so we don't step on each other.

**Blessing specifically:** your screen gets reached via `Navigator.push()`, not a bottom nav tab — coordinate with Ralph, Faith, and Louis on how they'll navigate to your screen (e.g. passing a `Pharmacy` object or an id).

## 4. Branching workflow

```bash
git checkout main
git pull
git checkout -b feature/<your-feature-name>   # e.g. feature/search
```

Work inside your feature folder, commit as you go, push your branch, open a PR into `main` when it's ready. Don't push directly to `main`.

```bash
git push -u origin feature/<your-feature-name>
```

## 5. Wiring your screen into the app

`root_shell.dart` currently shows a placeholder for each tab (Home, Search, Map, Profile). Once your screen exists, replace your placeholder with your real widget (import it at the top, swap it into the `_tabs` list) as part of your PR — don't edit anyone else's tab.

Blessing: no placeholder to swap — just make sure your screen accepts whatever the calling screen passes in (e.g. a `Pharmacy` object).

## 6. Before you push

```bash
flutter analyze     # no warnings
flutter run          # confirm it actually builds and the bottom nav still works
```

Questions → group chat, don't guess.
