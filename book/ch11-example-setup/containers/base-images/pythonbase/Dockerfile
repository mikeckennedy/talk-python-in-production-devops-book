FROM linux-example-base:latest

RUN mkdir /apps

ENV PATH=/venv/bin:$PATH
ENV PATH=/root/.cargo/bin:$PATH
ENV PATH="/root/.local/bin/:$PATH"

# Install Rust/Cargo for local builds of Rust-based Python packages
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up a virtual env to use for whatever app is destined for this container.
RUN uv venv --python 3.14 /venv

# Have the venv activate itself if we login via docker run/exec:
RUN echo "\nsource /venv/bin/activate\n" >> /root/.zshrc

# Install some handy utilities if you want them for debugging within the container
RUN --mount=type=cache,target=/root/.cache uv pip install httpie pls

RUN /venv/bin/python --version

RUN echo "We're good."
