#!/usr/bin/env python3
"""Validate structured Awesome Haskell entries against the repository schema."""

from __future__ import annotations

import json
import sys
from datetime import date, datetime
from pathlib import Path
from typing import Any

import yaml
from jsonschema import Draft202012Validator, FormatChecker

ROOT = Path(__file__).resolve().parents[1]
SCHEMA_PATH = ROOT / "schema" / "entry.schema.json"
DATA_ROOT = ROOT / "data"


def normalize_yaml_values(value: Any) -> Any:
    """Convert YAML-native date values into the ISO strings used by the schema."""
    if isinstance(value, (date, datetime)):
        return value.isoformat()
    if isinstance(value, list):
        return [normalize_yaml_values(item) for item in value]
    if isinstance(value, dict):
        return {key: normalize_yaml_values(item) for key, item in value.items()}
    return value


def load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return normalize_yaml_values(yaml.safe_load(handle))


def format_path(parts: list[Any]) -> str:
    if not parts:
        return "<root>"
    rendered = ""
    for part in parts:
        if isinstance(part, int):
            rendered += f"[{part}]"
        else:
            rendered += ("." if rendered else "") + str(part)
    return rendered


def main() -> int:
    schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
    validator = Draft202012Validator(schema, format_checker=FormatChecker())
    files = sorted(DATA_ROOT.rglob("*.yaml"))

    if not files:
        print("No YAML entries found under data/.", file=sys.stderr)
        return 1

    failures = 0
    for path in files:
        relative = path.relative_to(ROOT)
        try:
            document = load_yaml(path)
        except yaml.YAMLError as error:
            failures += 1
            print(f"{relative}: invalid YAML: {error}", file=sys.stderr)
            continue

        errors = sorted(
            validator.iter_errors(document),
            key=lambda error: list(error.absolute_path),
        )
        if errors:
            failures += 1
            for error in errors:
                location = format_path(list(error.absolute_path))
                print(f"{relative}:{location}: {error.message}", file=sys.stderr)
        else:
            print(f"OK {relative}")

    if failures:
        print(f"Validation failed for {failures} file(s).", file=sys.stderr)
        return 1

    print(f"Validated {len(files)} structured entry file(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
