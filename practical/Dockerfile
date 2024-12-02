FROM nixos/nix:latest

WORKDIR /app

RUN mkdir -p /etc/nix && echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

COPY . /app/

RUN nix build .#defaultPackage.aarch64-linux

ENV PATH="/app/result/bin:${PATH}"

CMD ["/bin/sh"]
