#!/usr/bin/env python3
"""Receive H3863 telemetry over serial, log CSV frames, and track per-device loss."""

import argparse
import csv
import sys
import time
from collections import defaultdict

import serial

HEADER = ["device_id", "seq", "temperature_c", "humidity_pct", "pressure_hpa"]
STATS_EVERY_S = 5.0
SILENCE_WARN_S = 2.0


def parse_frame(line, rows):
    fields = next(csv.reader([line]))
    if len(fields) == 5:
        device_id, seq = int(fields[0]), int(fields[1])
        values = fields[2:]
        if not 1 <= device_id <= 255:
            raise ValueError("device_id must be between 1 and 255")
    elif len(fields) == 4:
        device_id, seq = 0, int(fields[0])
        values = fields[1:]
    else:
        raise ValueError("expected a four- or five-column CSV frame")

    if not 1 <= seq <= rows:
        raise ValueError("seq is outside the configured dataset range")
    if any(not value.strip() for value in values):
        raise ValueError("empty sensor field")
    return device_id, seq, values


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("port", nargs="?", default="/dev/ttyUSB0")
    parser.add_argument("baud", nargs="?", type=int, default=115200)
    parser.add_argument("output", nargs="?", default="received.csv")
    parser.add_argument("rows", nargs="?", type=int, default=20)
    args = parser.parse_args()

    if args.rows < 1:
        parser.error("rows must be greater than zero")

    stats = defaultdict(lambda: {"total": 0, "lost": 0, "duplicates": 0, "last_seq": None})
    start = time.monotonic()
    last_rx = start
    last_stats = start
    warned = False
    total = 0

    with serial.Serial(args.port, args.baud, timeout=0.5) as ser:
        print("[recv] %s @ %d, rows=%d, output=%s" %
              (args.port, args.baud, args.rows, args.output))
        with open(args.output, "w", newline="", encoding="utf-8") as output:
            writer = csv.writer(output)
            writer.writerow(HEADER)

            while True:
                raw = ser.readline()
                now = time.monotonic()
                if not raw:
                    if now - last_rx > SILENCE_WARN_S and not warned:
                        print("[WARN] no data for %.1f seconds" % SILENCE_WARN_S)
                        warned = True
                    continue

                line = raw.decode("utf-8", "replace").strip()
                if not line:
                    continue

                try:
                    device_id, seq, values = parse_frame(line, args.rows)
                except (ValueError, csv.Error):
                    print("[log] %s" % line)
                else:
                    device = stats[device_id]
                    previous = device["last_seq"]
                    if previous is not None:
                        delta = (seq - previous) % args.rows
                        if delta == 0:
                            device["duplicates"] += 1
                            print("[DUP] device_id=%d seq=%d" % (device_id, seq))
                        elif delta > 1:
                            missing = delta - 1
                            device["lost"] += missing
                            print("[LOST] device_id=%d missing=%d before seq=%d" %
                                  (device_id, missing, seq))

                    device["last_seq"] = seq
                    device["total"] += 1
                    total += 1
                    writer.writerow([device_id, seq] + values)
                    output.flush()
                    last_rx = now
                    warned = False
                    if total <= 10:
                        print("[%d] %s" % (total, line))

                if now - last_stats >= STATS_EVERY_S:
                    elapsed = now - start
                    summary = ", ".join(
                        "ID %d: rx=%d lost=%d duplicate=%d last_seq=%s rate=%.1f/s" %
                        (device_id, item["total"], item["lost"], item["duplicates"],
                         item["last_seq"], item["total"] / elapsed if elapsed else 0)
                        for device_id, item in sorted(stats.items())
                    )
                    print("[STATS] total=%d elapsed=%.0fs %s" % (total, elapsed, summary))
                    last_stats = now


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n[recv] stopped")
    except serial.SerialException as exc:
        print("[recv] serial error: %s" % exc, file=sys.stderr)
        sys.exit(1)
