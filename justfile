# List all commands.
default:
  @just --list

# Build docs.
docs:
  rm -rf docs/build docs/source/_autosummary
  uv run make -C docs html
  echo Docs are in $PWD/docs/build/html/index.html

# Do a dev install.
dev:
  uv sync --all-extras --dev

# Run code checks.
check:
  #!/usr/bin/env bash

  error=0
  trap error=1 ERR

  echo
  (set -x; uv run ruff check src/ tests/ docs/source/ examples/ )
  test $? = 0

  echo
  ( set -x; uv run ruff format --check src/ tests/ docs/source/ examples/ )
  test $? = 0

  echo
  ( set -x; uv run mypy src/ tests/ docs/source/ examples/ )
  test $? = 0

  echo
  ( set -x; uv run pytest --cov=src --cov-report term-missing )
  test $? = 0

  echo
  ( set -x; uv run make -C docs doctest )
  test $? = 0

  test $error = 0

# Auto-fix code issues.
fix:
  uv run ruff format src/ tests/ docs/source/ examples/
  uv run ruff check --fix src/ tests/ docs/source/ examples/

# Build a release.
build:
  uv build
