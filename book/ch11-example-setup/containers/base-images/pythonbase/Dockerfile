FROM linux-example-base:latest

RUN mkdir /apps

ENV PATH=/venv/bin:$PATH
ENV PATH=/root/.cargo/bin:$PATH
ENV PATH="/root/.local/bin/:$PATH"

# Install Rust/Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# set up a virtual env to use for whatever app is destined for this container.
# RUN uv venv --python 3.13.0 --seed /venv
RUN uv venv --python 3.13.0 /venv

RUN echo "\nsource /venv/bin/activate\n" >> /root/.zshrc
RUN uv --version


# Install some handy utilities if you want them for debugging within the container
# RUN uv pip install httpie glances pls

# Install some of the common packages that (many) don't change often so later images build faster.

# Main dependencies
RUN --mount=type=cache,target=/root/.cache uv pip install --upgrade flask pydantic


# Base web servers for a minimum version
RUN --mount=type=cache,target=/root/.cache uv pip install --upgrade granian[pname]

RUN echo "We're good:"
RUN /venv/bin/python --version
