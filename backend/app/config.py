"""Cấu hình từ biến môi trường / backend/.env (đã gitignore). Không hardcode secret."""

from __future__ import annotations

from functools import lru_cache
from pathlib import Path

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_DIR = Path(__file__).resolve().parent.parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=BACKEND_DIR / ".env", env_file_encoding="utf-8-sig", extra="ignore"
    )

    gemini_api_key: str = Field(default="", description="GEMINI_API_KEY")
    # Tên model KHÔNG được xác minh bằng API trong repo này; run_eval.py --list-models
    # (cần key) in danh sách model thật để chọn. Đổi qua biến GEMINI_MODEL.
    gemini_model: str = "gemini-2.5-flash"

    index_path: Path = BACKEND_DIR / "data" / "protocols_index.json"

    llm_timeout_s: float = 12.0
    llm_max_attempts: int = 2  # tổng số lần gọi (1 lần gốc + retry), có giới hạn
    llm_retry_backoff_s: float = 0.5

    retrieval_top_k: int = 3
    retrieval_min_score: float = 2.0  # cổng thô, chọn thủ công, chưa kiểm định

    # Tùy chọn: nếu đặt thì yêu cầu header X-API-Key. Token nhúng trong app KHÔNG phải
    # bí mật thật; chỉ giảm lạm dụng ngẫu nhiên (xem README).
    api_auth_token: str = ""


@lru_cache
def get_settings() -> Settings:
    return Settings()
