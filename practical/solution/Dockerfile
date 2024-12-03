FROM nixos/nix:latest

WORKDIR /workdir

RUN mkdir -p /etc/nix && echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf

COPY . /workdir/

RUN nix build .#defaultPackage.x86_64-linux

ENV PATH="/workdir/result/bin:${PATH}"

CMD ["/bin/sh"]
