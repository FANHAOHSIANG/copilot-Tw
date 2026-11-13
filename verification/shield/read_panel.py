"""Verify Shield numeric crops from a saved frame. Requires Pillow and Tesseract."""
import argparse
import csv
import io
import json
import re
import subprocess

from PIL import Image, ImageOps


MIN_FRAME_HEIGHT = 70


def crop_box(value):
    try:
        coords = tuple(float(part) for part in value.split(","))
    except ValueError as error:
        raise argparse.ArgumentTypeError("Expected four decimal coordinates") from error
    if len(coords) != 4 or not (0 <= coords[0] < coords[2] <= 1 and 0 <= coords[1] < coords[3] <= 1):
        raise argparse.ArgumentTypeError("Expected x1,y1,x2,y2 as fractions of the input frame")
    return coords


def read_number(frame, box, invert):
    width, height = frame.size
    area = frame.crop(tuple(round(v * (width, height)[i % 2]) for i, v in enumerate(box)))
    if area.width < 15 or area.height < 14:
        return None
    area = area.convert("L")
    if invert:
        area = ImageOps.invert(ImageOps.autocontrast(area))
    buffer = io.BytesIO()
    area.save(buffer, format="PNG")
    output = subprocess.run([
        "tesseract", "stdin", "stdout", "--psm", "8",
        "-c", "tessedit_char_whitelist=0123456789", "tsv",
    ], input=buffer.getvalue(), capture_output=True, check=True, timeout=8)
    words = [row for row in csv.DictReader(io.StringIO(output.stdout.decode()), delimiter="\t")
             if row["text"].strip()]
    if len(words) != 1:
        return None
    word = words[0]
    if not re.fullmatch(r"[0-9]{1,4}", word["text"]) or float(word["conf"]) < 70:
        return None
    return int(word["text"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("frame")
    parser.add_argument("--distance", type=crop_box, required=True)
    parser.add_argument("--limit", type=crop_box, required=True)
    args = parser.parse_args()
    with Image.open(args.frame) as frame:
        if frame.height < MIN_FRAME_HEIGHT:
            print(json.dumps({"status": "frame_too_small", "minimum_height_px": MIN_FRAME_HEIGHT}))
            return
        distance = read_number(frame, args.distance, True)
        limit = read_number(frame, args.limit, False)
    if distance is None or not 0 < distance <= 5000 or limit not in range(10, 131, 10):
        print(json.dumps({"status": "unconfirmed"}))
        return
    print(json.dumps({"status": "candidate", "distance_m": distance, "camera_limit_kph": limit}))


if __name__ == "__main__":
    main()
