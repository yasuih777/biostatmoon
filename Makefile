PYTHON_VERSION = 3.10.13
QUARTO_VERSION = 1.4.529
PYSCRIPT_DIR = src
CLI_SCRIPT = cli.py

# R script
.PHONY: install_r
install_r: # install R
	wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
	| sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
	sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
	sudo apt install --no-install-recommends r-base

.PHONY: install_rstudio
install_rstudio: # install RStudio server
	wget https://rstudio.org/download/latest/stable/server/bionic/rstudio-server-latest-amd64.deb
	sudo apt install gdebi
	sudo gdebi rstudio-server-latest-amd64.deb

.PHONY: start_rstudio
start_rstudio: # start RStudio server
	sudo rstudio-server start

.PHONY: stop_rstudio
stop_rstudio: # start RStudio server
	sudo rstudio-server stop

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