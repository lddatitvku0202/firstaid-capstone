"""Sinh backend/data/protocols_index.json từ app/assets/protocols/protocols_v1.json.

Chỉ nạp mục source_verification == "verified". Không thêm nội dung y khoa mới:
trường `aliases` chỉ là từ đồng nghĩa để truy xuất (không hiển thị cho người dùng).

Chạy:  python scripts/build_index.py
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

BACKEND = Path(__file__).resolve().parent.parent
SRC = BACKEND.parent / "app" / "assets" / "protocols" / "protocols_v1.json"
OUT = BACKEND / "data" / "protocols_index.json"

# Từ khóa truy xuất do nhóm tự đặt (cách gọi thông thường của người dùng),
# KHÔNG phải nội dung y khoa. Chưa được rà soát.
ALIASES: dict[str, list[str]] = {
    "bleeding_wounds_severe": [
        "chảy máu", "máu chảy", "vết thương hở", "đứt tay", "cắt vào tay", "máu phun",
        "mất máu", "băng ép", "cầm máu", "dao cắt", "rách da",
    ],
    "burns_thermal_chemical": [
        "bỏng", "phỏng", "nước sôi", "bị bỏng", "bỏng dầu", "bỏng lửa", "bỏng điện",
        "bỏng axit", "hóa chất bắn vào da", "bàn là", "bếp",
    ],
    "choking_adult_child": [
        "hóc", "nghẹn", "mắc nghẹn", "kẹt họng", "nuốt phải", "hóc xương", "hóc đồ ăn",
        "ho sặc", "tắc thở", "nghẹt thở", "người lớn", "trẻ em", "bé trên 1 tuổi",
    ],
    "choking_baby": [
        "hóc", "nghẹn", "sặc sữa", "em bé", "sơ sinh", "dưới 1 tuổi", "bé nhỏ",
        "con nhỏ bị nghẹn", "tháng tuổi", "nuốt phải",
    ],
    "cpr_adult_adolescent": [
        "ngừng tim", "ngưng tim", "ngừng thở", "ngưng thở", "bất tỉnh", "không thở",
        "ép tim", "hô hấp nhân tạo", "ép ngực", "người lớn", "ngất xỉu", "không phản ứng",
    ],
    "cpr_baby_child": [
        "ngừng tim", "ngưng tim", "ngừng thở", "ngưng thở", "bất tỉnh", "không thở",
        "ép tim", "hô hấp nhân tạo", "ép ngực", "em bé", "trẻ em", "sơ sinh", "con nhỏ",
        "không phản ứng",
    ],
}


def main() -> int:
    raw = SRC.read_bytes()
    data = json.loads(raw.decode("utf-8"))
    entries = []
    skipped = []
    for p in data["protocols"]:
        if p.get("source_verification") != "verified":
            skipped.append(p["code"])
            continue
        steps = " ".join(s["text"] for s in p["steps"])
        do_not = " ".join(d["text"] for d in p.get("do_not", []))
        entries.append(
            {
                "code": p["code"],
                "title": p["title"],
                "topic_id": p["topic_id"],
                "severity": p["severity"],
                "target_audience": p["target_audience"],
                "age_group": p["age_group"],
                "version": p["version"],
                "source_verification": p["source_verification"],
                "clinical_review": p["clinical_review"],
                "reuse_permission": p["reuse_permission"],
                "citations": p["citations"],
                "aliases": ALIASES.get(p["code"], []),
                "text": f"{p['title']}. {steps} {do_not}",
            }
        )
    out = {
        "index_version": 1,
        "source_file": "app/assets/protocols/protocols_v1.json",
        "source_data_version": data["data_version"],
        "source_sha256": hashlib.sha256(raw).hexdigest(),
        "skipped_not_verified": skipped,
        "protocols": entries,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {OUT} ({len(entries)} protocols, skipped {skipped})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
