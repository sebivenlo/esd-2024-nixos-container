### Instructions

This tutorial will guide you through creating a Docker container that utilizes Nix for package management, incorporating Nix Flakes to manage dependencies and configurations. By the end, you'll have a functional Docker container configured with Nix, built using the exact code provided in the solution directory, in case you struggle with it.

---

### 1. Create the Dockerfile

First, in an this folder, create a file named `Dockerfile`. This file will contain instructions for building your Docker image.

---

### 2. Specify the Base Image

Begin by specifying the base image for your Docker build. Add the following line to your `Dockerfile`:

```dockerfile
FROM nixos/nix:latest
```

This line tells Docker to use the latest NixOS image as the foundation for your container. The `nixos/nix` image includes the Nix package manager, providing a minimal environment with Nix pre-installed.

---

### 3. Set the Working Directory

Define the working directory inside the container where subsequent commands will be executed. Add the following line:

```dockerfile
WORKDIR /workdir
```

This command sets `/workdir` as the working directory. If this directory doesn't exist, Docker will create it automatically. Setting a working directory helps organize files and ensures that commands run in the intended location.

---

### 4. Enable Experimental Nix Features

To utilize Nix Flakes, you need to enable experimental features in Nix. Add the following line:

```dockerfile
RUN mkdir -p /etc/nix && echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf
```

This command creates the `/etc/nix` directory (if it doesn't exist) and writes a configuration line to `/etc/nix/nix.conf` to enable the `nix-command` and `flakes` experimental features. This step is essential for using Nix Flakes, as they are still experimental and require explicit enabling.

---

### 5. Copy Project Files into the Container

Transfer the contents of your current directory on the host machine into the container's `/workdir` directory by adding:

```dockerfile
COPY . /workdir/
```

This command copies all files from your current directory to the `/workdir` directory inside the container, allowing the Docker build process to access your project's files, including the `flake.nix` file.

---

### 6. Build the Nix Package

Instruct Docker to build the default package specified in the `flake.nix` file for the appropriate system architecture:


```dockerfile
RUN nix build .#defaultPackage.${system}-linux
```

This command uses `nix build` to compile the package defined in the flake's outputs. The `.#defaultPackage.${system}-linux` syntax specifies the `defaultPackage` attribute for the `${system}` system (could have any name instead of defaultPackage, multiple are possible as well ). If you're using a different architecture (e.g., `x86_64-linux` for most desktop PCs or  `aarch64-linux` on Apple M Chips ), adjust this line accordingly.

---

### 7. Update the PATH Environment Variable

Ensure that the binaries from the build result are accessible by updating the `PATH` environment variable:

```dockerfile
ENV PATH="/workdir/result/bin:${PATH}"
```

This line prepends the path to the build result's binary directory to the existing `PATH`, allowing the system to locate and execute these binaries without needing their full paths.

---

### 8. Set the Default Command

Specify the default command to run when the container starts:

```dockerfile
CMD ["/bin/sh"]
```

This command tells Docker to launch a shell (`/bin/sh`) when the container runs, enabling interactive use or further command execution.

---

### 9. Define the Nix Flake Configuration

In the same directory, create a file named `flake.nix` with the following content:

```nix
{
  description = "Flake for nixos-container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";  # Change to "aarch64-linux" if using an Apple M Chip
    pkgs = import nixpkgs { inherit system; };
  in {
    defaultPackage.${system} = pkgs.buildEnv {
      name = "tools";
      paths = with pkgs; [
        cowsay
        vim
      ];
    };
  };
}
```
I know this is a lot thrown at you. Large parts of it are just boilerplate. below is a description what happens. But no worries if you dont get it instantly, this is just a simple showcase. After is a link to excercises on the Nix language, letting some things become more clear. 

This `flake.nix` file defines the Nix Flake, specifying inputs and outputs for the project:

- **description**: Provides a brief description of the flake's purpose.
- **inputs**: Specifies the dependencies of the flake. Here, it references the `nixpkgs` repository from GitHub, pinned to the `nixos-24.11` branch. This ensures that the flake uses a specific version of the Nix Packages collection, promoting reproducibility.
- **outputs**: Defines what the flake produces.
  - `system`: Specifies the target system architecture. Change this to match your system (`"x86_64-linux"` for most PCs, `"aarch64-linux"` for ARM-based systems like Apple's M1).
  - `pkgs`: Imports the `nixpkgs` package set for the specified system, allowing access to packages compatible with that architecture.
  - `defaultPackage.${system}`: Sets the default package output for the specified system architecture.
  - `pkgs.buildEnv`: Creates an environment that bundles multiple packages together.
    - `name`: Names the environment "tools".
    - `paths`: Lists the packages to include in the environment. Here, `cowsay` and `vim` are included.

---

### 10. Build and Run the Docker Image

With both `Dockerfile` and `flake.nix` in place, you can now build and run your Docker image:

```sh
# Build the Docker image
docker build -t nix-flake-container .

# Run the Docker container
docker run -it nix-flake-container
```

The `docker build` command creates the Docker image and tags it as `nix-flake-container`. The `docker run` command starts a new container from the image in interactive mode (`-it`), allowing you to interact with the shell inside the container.

---

### 11. Verify the Installed Packages

Once inside the container's shell, verify that the specified packages (`cowsay` and `vim`) are installed and accessible:

```sh
# Check cowsay installation
cowsay "Hello, Nix!"

# Check vim installation
vim --version
```

If both commands execute successfully, it confirms that your Docker container is correctly set up with Nix and the specified packages.

---

### 12. Add another program

Continue by searching through [the Nix packages](https://search.nixos.org/packages) and add an addtional program,
If you got no idea: you could write a simple java or c hello world using vim, search for the packages containing the dependencies needed and add them to the list.

---

### 13. Nix Language tutorial

Finally, start with these short excercises on Nix [(O)](https://nixcloud.io/tour/?id=introduction/nix)
```
