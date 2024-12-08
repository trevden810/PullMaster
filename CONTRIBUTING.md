# Contributing to PullMaster

Thank you for your interest in contributing to PullMaster! This guide will help you get started with contributing to this World of Warcraft Classic addon.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)

## Code of Conduct
This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## Getting Started
1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/PullMaster.git`
3. Add the original repo as upstream: `git remote add upstream https://github.com/trevden810/PullMaster.git`
4. Create a new branch for your changes

## Development Process

### Branch Naming Convention
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `dungeon/*` - New dungeon implementations
- `docs/*` - Documentation updates
- `test/*` - Test improvements

### Commit Messages
- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Reference issues and pull requests in the commit body

### Adding a New Dungeon
1. Create a branch using the convention `dungeon/dungeon-name`
2. Follow the Deadmines template in `dungeons/deadmines/`
3. Implement all required components:
   - Patrol paths
   - Boss data
   - Safe spots
   - Tactical routing
4. Add corresponding tests
5. Update documentation

## Pull Request Process
1. Update the README.md with details of changes if needed
2. Add/update tests for any new functionality
3. Ensure all tests pass
4. Update documentation as needed
5. Follow the pull request template

## Coding Standards
- Follow existing LUA style in the codebase
- Use WoW Classic API conventions
- Comment complex logic
- Keep functions focused and minimal

## Testing
- All new features must include tests
- Run the full test suite before submitting PRs
- Follow the test naming conventions in existing tests
- Document any new test dependencies

## Questions?
Open an issue or join our Discord server for help!
