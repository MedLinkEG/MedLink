# MedLink

MedLink Egypt: an agentic AI healthcare marketplace for medicines and medical devices.
Graduation project, Nile University, Computer Science.

## Repository layout

- `mobile/`: Flutter app (Android and iOS)
- `backend/core-api/`: Spring Boot REST API (Java 21, PostgreSQL)

## Mobile app

**Flutter version:** 3.47.2 (stable). Check yours with `flutter --version`.

### Run

    cd mobile
    flutter pub get
    flutter run

### Before opening a PR

    dart format lib test
    flutter analyze
    flutter test

### Structure

    lib/
    ├── core/       router, network (dio), theme, constants, utils
    ├── shared/     reusable widgets
    └── features/   auth, marketplace, search, map, chat,
                    notifications, ai_assistant, profile
                    (each with data/, domain/, presentation/)

### Environment variables

Copy `mobile/.env.example` to `mobile/.env` and fill in the values.
Never commit `.env` or API keys.

## Backend

### Running with Docker

1. Copy the env file and fill in your values (defaults work for local dev):

       cp .env.example .env

2. Start everything from the repo root:

       docker compose up --build

   - Spring Boot API → `http://localhost:8080`
   - Swagger UI → `http://localhost:8080/swagger-ui/index.html`

3. Stop without losing data:

       docker compose stop

4. Wipe everything (fresh DB):

       docker compose down -v

### Environment variables

Copy `.env.example` to `.env` at the repo root. Never commit `.env`.

## Workflow

- Never push directly to `main`. Open a pull request; it needs 1 approval and passing CI.
- Branch names: `feature/<name>`, `fix/<name>`, `chore/<name>`.
- Commit messages: `feat: ...`, `fix: ...`, `chore: ...`.
