FROM ubuntu:24.04

# ビルド引数と非対話モードの設定
ARG OPENVSCODE_VERSION="v1.97.0"
ENV DEBIAN_FRONTEND=noninteractive

# 基本ツールのインストールとパッケージキャッシュの削除
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    wget \
    unzip \
    cmake \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Starship のインストール
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# openvscode-server の取得と展開（リリースタグ名の openvscode-server- を指定）
RUN wget "https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-${OPENVSCODE_VERSION}/openvscode-server-${OPENVSCODE_VERSION}-linux-x64.tar.gz" \
    && tar -xzf "openvscode-server-${OPENVSCODE_VERSION}-linux-x64.tar.gz" \
    && mv "openvscode-server-${OPENVSCODE_VERSION}-linux-x64" /opt/openvscode-server \
    && rm "openvscode-server-${OPENVSCODE_VERSION}-linux-x64.tar.gz"

# 設定ファイルの配置
COPY .bashrc /root/.bashrc
COPY product.json /opt/openvscode-server/product.json

# Starship プリセット適用と作業ディレクトリ作成
RUN mkdir -p /root/.config \
    && starship preset catppuccin-powerline -o /root/.config/starship.toml \
    && mkdir -p /workspace

# 起動スクリプトの配置
COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /workspace
EXPOSE 8080
CMD ["/start.sh"]
