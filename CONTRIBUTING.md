# Contributing to PullMaster

Thank you for your interest in contributing to PullMaster! This guide will help you get started.

## Development Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`/run PullMasterTest`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Branch Naming Convention

- `feature/*` - For new features
- `bugfix/*` - For bug fixes
- `dungeon/*` - For new dungeon implementations
- `test/*` - For test improvements
- `docs/*` - For documentation updates

## Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests in the commit body

## Adding New Dungeons

1. Create a new branch using `dungeon/dungeon-name`
2. Follow the Deadmines template in `dungeons/deadmines`
3. Implement required components:
   - Patrol paths
   - Boss data
   - Safe spots
   - Tactical routing
4. Add tests following `tests/deadmines_test.lua`
5. Update documentation

## Testing

- All new features must include tests
- Run the full test suite before submitting PRs
- Document any new test dependencies

## Code Style

- Follow existing LUA code style
- Use WoW Classic API conventions
- Comment complex logic
- Keep functions focused and minimal

## Questions?

Open an issue for any questions about contributing!