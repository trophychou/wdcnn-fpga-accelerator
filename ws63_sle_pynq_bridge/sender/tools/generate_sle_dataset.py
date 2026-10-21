#!/usr/bin/env python3
"""Generate a WS63 SLE dataset header from a CSV file."""

import argparse
import csv
from pathlib import Path


EXPECTED_HEADER = ["seq", "temperature_c", "humidity_pct", "pressure_hpa"]
MAX_FRAME_BYTES = 180


def load_rows(csv_path: Path) -> list[str]:
    with csv_path.open("r", encoding="utf-8-sig", newline="") as stream:
        reader = csv.reader(stream)
        header = next(reader, None)
        if header != EXPECTED_HEADER:
            raise ValueError(f"expected header {EXPECTED_HEADER}, got {header}")

        frames = []
        expected_seq = 1
        for line_number, row in enumerate(reader, start=2):
            if len(row) != 4 or any(not field.strip() for field in row):
                raise ValueError(f"line {line_number}: expected four non-empty columns")
            try:
                seq = int(row[0])
            except ValueError as exc:
                raise ValueError(f"line {line_number}: seq must be an integer") from exc
            if seq != expected_seq:
                raise ValueError(f"line {line_number}: expected seq {expected_seq}, got {seq}")

            frame = ",".join(field.strip() for field in row) + "\\r\\n"
            frame_bytes = len(frame.encode("utf-8"))
            if frame_bytes > MAX_FRAME_BYTES:
                raise ValueError(
                    f"line {line_number}: frame is {frame_bytes} bytes, max is {MAX_FRAME_BYTES}"
                )
            frames.append(frame)
            expected_seq += 1

    if not frames:
        raise ValueError("dataset must contain at least one data row")
    return frames


def write_header(output_path: Path, frames: list[str]) -> None:
    lines = [
        "/* Generated from dataset.csv. Do not edit by hand. */",
        "#ifndef SLE_DATASET_DATA_H",
        "#define SLE_DATASET_DATA_H",
        "",
        "static const char *const g_sle_dataset[] = {",
    ]
    lines.extend(f'    "{frame}",' for frame in frames)
    lines.extend(
        [
            "};",
            "#define SLE_DATASET_ROWS (sizeof(g_sle_dataset) / sizeof(g_sle_dataset[0]))",
            "",
            "#endif",
            "",
        ]
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines), encoding="ascii", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("csv_path", type=Path)
    parser.add_argument("output_path", type=Path)
    args = parser.parse_args()
    frames = load_rows(args.csv_path)
    write_header(args.output_path, frames)
    print(f"generated {len(frames)} frames in {args.output_path}")


if __name__ == "__main__":
    main()
