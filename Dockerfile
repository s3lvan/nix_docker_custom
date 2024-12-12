# Use an official Ubuntu image as a parent image
FROM ubuntu:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libzmq5 \
    libzmq3-dev \
    liblog4cxx-dev \
    libpcap0.8 \
    curl \
    git \
    meson \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Create /nix directory and set permissions
RUN mkdir -m 0755 /nix && chown root /nix

# Install Nix
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Source Nix profile to ensure nix command is available and check version
RUN chmod +x /etc/profile.d/nix.sh
RUN . /etc/profile.d/nix.sh && nix-env --version

# Clone the NixOS/nix repository
RUN git clone https://github.com/NixOS/nix.git /usr/src/app/nix

# Set the working directory to the cloned repository
WORKDIR /usr/src/app/nix

# Run nix develop with experimental features
RUN . /etc/profile.d/nix.sh && nix develop --extra-experimental-features nix-command --extra-experimental-features flakes


#RUN . /etc/profile.d/nix.sh nix develop --extra-experimental-features nix-command --extra-experimental-features flakes && mesonConfigurePhase && ninjaBuildPhase
RUN ls
#RUN . /etc/profile.d/nix.sh && . /etc/profile.d/nix.sh && nix develop --extra-experimental-features nix-command --extra-experimental-features flakes && ninjaBuildPhase

#RUN . /etc/profile.d/nix.sh && mesonConfigurePhase && ninjaBuildPhase

# Optionally, switch to a non-root user (e.g., nixuser) if needed
# RUN useradd -m -s /bin/bash nixuser
# USER nixuser

# Start an interactive shell
#CMD ["/bin/bash"]
CMD ["/bin/bash", "-c", "/src_buid_entrypoint.sh"]
