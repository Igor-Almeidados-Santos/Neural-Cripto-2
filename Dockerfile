# ./Dockerfile
FROM python:3.11.12-slim

# Configuração de variáveis de ambiente
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on

# Instalação de dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuração do diretório de trabalho
WORKDIR /app

# Instalação de Poetry
RUN pip install --upgrade pip \
    && pip install poetry==1.7.1

# Configurando Poetry para não criar ambientes virtuais no container
RUN poetry config virtualenvs.create false

# Cópia dos arquivos de gerenciamento de dependências
COPY pyproject.toml poetry.lock* ./

# Instalação das dependências
RUN poetry install --no-interaction --no-ansi --no-root

# Copia o código-fonte
COPY . .

# Comando padrão para execução
CMD ["python", "-m", "src.main"]