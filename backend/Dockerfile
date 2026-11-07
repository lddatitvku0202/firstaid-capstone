# Chưa build thử trên máy này (không có Docker). Xem README.md.
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /srv

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY data ./data

# Không COPY .env: truyền GEMINI_API_KEY qua biến môi trường của nền tảng.
RUN useradd --create-home appuser && chown -R appuser /srv
USER appuser

EXPOSE 8000
# $PORT do nền tảng cấp (Render/Railway/Fly...); mặc định 8000.
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
