"""Schema cố định của POST /v1/route-situation."""

from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator

Category = Literal[
    "cardiac_arrest_cpr",
    "choking",
    "bleeding_wounds",
    "burns",
    "call_115_now",  # do quy tắc xác định (không qua LLM)
    "out_of_scope",
]
TOPIC_CATEGORIES = ("cardiac_arrest_cpr", "choking", "bleeding_wounds", "burns")


class RouteRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    text: str = Field(min_length=1, max_length=1000)

    @field_validator("text")
    @classmethod
    def _strip(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("text rỗng")
        return v


class Source(BaseModel):
    model_config = ConfigDict(extra="forbid")

    source_id: str
    pages: str


class RouteResult(BaseModel):
    """Kết quả cuối. Chỉ có đúng 5 trường này."""

    model_config = ConfigDict(extra="forbid")

    category: Category
    protocol_code: str | None
    confidence_note: str = Field(max_length=300)
    sources: list[Source]
    uncertain: bool


class RouteError(Exception):
    """Lỗi có mã ổn định để app fallback sang luồng cục bộ."""

    def __init__(
        self,
        code: str,
        message: str,
        http_status: int = 502,
        detail: str | None = None,
        raw_output: str | None = None,
    ):
        super().__init__(message)
        self.code = code
        self.message = message
        self.http_status = http_status
        # Chỉ dùng nội bộ cho eval/gỡ lỗi; KHÔNG nằm trong body() trả cho app.
        self.detail = detail
        self.raw_output = raw_output

    def body(self) -> dict:
        return {
            "error": {
                "code": self.code,
                "message": self.message,
                "fallback": "use_local_triage",
            }
        }


# JSON schema đưa cho Gemini (response_json_schema). protocol_code do service
# thu hẹp thành enum các ứng viên truy xuất được.
def llm_response_schema(candidate_codes: list[str]) -> dict:
    return {
        "type": "object",
        "properties": {
            "category": {
                "type": "string",
                "enum": list(TOPIC_CATEGORIES) + ["out_of_scope"],
            },
            "protocol_code": {
                "type": ["string", "null"],
                "enum": candidate_codes + [None],
            },
            "confidence_note": {"type": "string"},
            "sources": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "source_id": {"type": "string"},
                        "pages": {"type": "string"},
                    },
                    "required": ["source_id", "pages"],
                },
            },
            "uncertain": {"type": "boolean"},
        },
        "required": [
            "category",
            "protocol_code",
            "confidence_note",
            "sources",
            "uncertain",
        ],
    }
