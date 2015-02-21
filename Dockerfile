FROM ubuntu:14.10
MAINTAINER Tyler Hampton

WORKDIR /home/dev
ENV HOME /home/dev
ENV SHELL /usr/bin/zsh
ENV RBENV_VERSION 2.1.5
ENV PROFILE $HOME/.zshrc

# This container has assumed that you've copied your SSH keys to the source directory
#
# Unfortunately, boot2docker doesn't have support for ssh agent forwarding so I can't use my hosts ssh to access cool stuff
ADD ssh $HOME/.ssh

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  git \
  autoconf \
  bison \
  libssl-dev \
  libyaml-dev \
  zlib1g-dev \
  irssi \
  subversion \
  ssh-client \
  curl \
  zsh \
  unzip \
  vim \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup home environment
RUN useradd dev

# Setup zsh and add-ons
#
# # #
RUN curl -L http://install.ohmyz.sh | bash
RUN wget --no-check-certificate https://raw.githubusercontent.com/howdoicomputer/dotfiles/4fa36534f0d8508415165f3a6a4354c351f06466/zshrc -O $HOME/.zshrc
RUN git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
RUN /usr/bin/zsh $HOME/.zshrc
RUN chsh dev -s /usr/bin/zsh

# Install VIM and all my delicious plugins
#
# # #
RUN mkdir -p $HOME/.vim/.tmp
RUN wget --no-check-certificate https://raw.githubusercontent.com/howdoicomputer/dotfiles/0716e8755fbfb364959336a817c52a357dd924b0/vimrc -O $HOME/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN yes | vim +PluginInstall +qall

# Setup rbenv and install bundler
#
# # #
#ENV PATH $HOME/.rbenv/bin:$PATH
#RUN wget -O - https://github.com/sstephenson/rbenv/archive/master.tar.gz \
  #| tar zxf - \
  #&& mv rbenv-master $HOME/.rbenv
#RUN wget -O - https://github.com/sstephenson/ruby-build/archive/master.tar.gz \
  #| tar zxf - \
  #&& mkdir -p $HOME/.rbenv/plugins \
  #&& mv ruby-build-master $HOME/.rbenv/plugins/ruby-build

#RUN echo 'eval "$(rbenv init -)"' >> $HOME/.profile
#RUN echo 'eval "$(rbenv init -)"' >> $HOME/.zshrc

#RUN rbenv install 1.9.3-p551
#RUN rbenv install 2.1.5
#RUN rbenv global 2.1.5
#RUN gem install --no-ri --no-rdoc bundler
#RUN rbenv rehash

RUN chown -R dev: /home/dev
USER dev
CMD zsh
