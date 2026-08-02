# Structured entry validation

The files under `data/` are an experimental machine-readable representation of reviewed Awesome Haskell entries.

`entry.schema.json` defines the current pilot contract. It checks:

- required identity and classification fields;
- allowed kinds, roles, recommendation levels, and maintenance statuses;
- ISO review dates and HTTPS URLs;
- non-empty recommendation, trade-off, alternative, evidence, and reviewer lists;
- the additional fields required for reviewed recommendations;
- accidental recommendation-only fields on discovery entries;
- unknown fields, which usually indicate a typo or an undocumented schema change.

Run validation locally with:

```sh
python -m pip install "jsonschema[format]>=4.23,<5" "PyYAML>=6,<7"
python scripts/validate_data.py
```

The same command runs in `.github/workflows/validate-data.yml` whenever structured data, the schema, or the validator changes.

The schema validates structure, not editorial truth. Passing validation does not prove that a recommendation is correct, that a project is maintained, or that cited evidence supports a claim. Those remain human review responsibilities.

This remains a pilot. After several categories use the format, the project should decide whether the schema provides enough value to justify the maintenance cost. If not, both `data/` and `schema/` can be removed without affecting the Haskell examples or Markdown guides.
