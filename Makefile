PYTHON_VERSION = 3.10.13
QUARTO_VERSION = 1.3.450
PYSCRIPT_DIR = src
CLI_SCRIPT = cli.py

# Python script
.PHONY: install_pyenv
install_pyenv: # install python version maneger tool
	sudo apt update
	sudo apt upgrade
	sudo apt install \
		libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev \
		libreadline-dev libbz2-dev libsqlite3-dev make gcc
	curl https://pyenv.run | bash
	echo '' >> ~/.bashrc
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(pyenv init --path)"' >> ~/.bashrc

.PHONY: install_poetry
install_poetry: # install python packages version and it's conflict maneger tool
	curl -sSL https://install.python-poetry.org | python3 -
	poetry config virtualenvs.in-project true

.PHONY: build_python
build_python:
	pyenv install ${PYTHON_VERSION}
	pyenv local ${PYTHON_VERSION}
	python -m pip install --upgrade pip
	poetry install

.PHONY: run_cli
run_cli:
	poetry run python ${CLI_SCRIPT}

.PHONY: format
format:
	poetry run black ${CLI_SCRIPT}
	poetry run black ${PYSCRIPT_DIR}
	poetry run isort ${CLI_SCRIPT}
	poetry run isort ${PYSCRIPT_DIR}

# Quarto script
.PHONY: install_quarto
install_quarto:
	wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
	sudo apt install ./quarto-${QUARTO_VERSION}-linux-amd64.deb
	rm quarto-${QUARTO_VERSION}-linux-amd64.deb

.PHONY: preview
preview:
	poetry run quarto preview

.PHONY: render
render:
	poetry run quarto render