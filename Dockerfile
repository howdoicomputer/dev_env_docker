FROM ubuntu:14.10
MAINTAINER Tyler Hampton

WORKDIR /home/dev
ENV HOME /home/dev
ENV SHELL /usr/bin/zsh
ENV PROFILE $HOME/.zshrc

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  git \
  irssi \
  subversion \
  ssh-client \
  tmux \
  curl \
  zsh \
  unzip \
  vim \
  wget && \
  apt-get clean

# Setup home environment
RUN useradd dev

# Setup zsh and add-ons
#
# # #
RUN curl -L http://install.ohmyz.sh | bash
ADD zshrc $HOME/.zshrc
RUN git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
RUN /usr/bin/zsh $HOME/.zshrc
RUN chsh dev -s /usr/bin/zsh

# Install VIM and all my delicious plugins
#
# # #
RUN mkdir -p $HOME/.vim/.tmp
ADD vimrc $HOME/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN yes | vim +PluginInstall +qall

# Setup git and commit_msg
#
# # #
RUN mkdir -p $HOME/.git_template/hooks
ADD commit-msg $HOME/.git_template/hooks/commit_msg
RUN git config --global init.templatedir $HOME/.git_template

# Add gitflow
#
# # #
RUN cd /usr/local/src && \
    curl -sLkO https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh && \
    chmod +x gitflow-installer.sh && \
    ./gitflow-installer.sh && \
    rm -rf /usr/local/src/gitflow*

# chown everything and drop into zsh on login
#
# # #
RUN chown -R dev: $HOME
USER dev
CMD zsh
