FROM ubuntu:22.04

# 基本ツール
RUN apt update && apt install -y curl git wget unzip
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y
# openvscode-server を取得
RUN wget https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.90.0/openvscode-server-v1.90.0-linux-x64.tar.gz \
    && tar -xzf openvscode-server-v1.90.0-linux-x64.tar.gz \
    && mv openvscode-server-v1.90.0-linux-x64 /opt/openvscode-server
COPY .bashrc /root/.bashrc

# 作業ディレクトリ
COPY product.json /opt/openvscode-server/product.json
RUN mkdir -p /root/.config && starship preset catppuccin-powerline -o /root/.config/starship.toml
RUN mkdir -p /workspace
WORKDIR /workspace

# 起動スクリプト
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
