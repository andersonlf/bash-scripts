#!/bin/bash

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`;

##
# proxy config: http://pac.zscaler.net/sicoob.com.br/sicoob.pac
##

##
# global variables
# make your changes here
#
GIT_DOTFILES_REPOSITORY="https://github.com/andersonlf/dotfiles.git";
GIT_BIN_REPOSITORY="https://github.com/andersonlf/bash-scripts.git";
LOGIN="anderson";

##
# backup $file
#
backup_file() {
  cp $1 $1.$TIMESTAMP;
}

##
# append text parameter $1 to file parameter $2
#
append_text_to_file() {
  echo $1 >> $2;
}

##
# configure dotfiles
#
configure_dotfiles() {
  su - $LOGIN -c "git -c http.proxy=$http_proxy -c http.sslverify=false clone $GIT_DOTFILES_REPOSITORY /home/$LOGIN/dotfiles;"
  su - $LOGIN -c "sh -x /home/$LOGIN/dotfiles/install $LOGIN dotfiles/work;"
}

##
# configure bin
#
configure_bin() {
  su - $LOGIN -c "git -c http.proxy=$http_proxy -c http.sslverify=false clone $GIT_BIN_REPOSITORY /home/$LOGIN/bin;"
}

##
# setting environment variables
#
confugure_profile() {
  FILE=/etc/profile;
  backup_file $FILE;
  append_text_to_file "export SISBRIDE_HOME=\"/home/$LOGIN/sisbride\";" $FILE;
  append_text_to_file "export JAVA_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.8.0_05\";" $FILE;
  append_text_to_file "export JRE_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.8.0_05\";" $FILE;
  append_text_to_file "export MAVEN_HOME=\"\$SISBRIDE_HOME/tools/apache-maven-3.1.1\";" $FILE;
  append_text_to_file "export ANT_HOME=\"\$SISBRIDE_HOME/tools/apache-ant-1.9.2\";" $FILE;
  append_text_to_file "export PATH=\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$ANT_HOME/bin:\$SISBRIDE_HOME/bin:\$PATH;" $FILE;
}

##
# setting 
#
configure_environment() {
  FILE=/etc/environment;
  backup_file $FILE;
  cp $FILE $FILE.noproxy;
  cp $FILE $FILE.proxy;
  append_text_to_file "http_proxy=\"$http_proxy\"" $FILE.proxy;
  append_text_to_file "https_proxy=\"$https_proxy\"" $FILE.proxy;
  append_text_to_file "ftp_proxy=\"$ftp_proxy\"" $FILE.proxy;
  append_text_to_file "no_proxy=\"$no_proxy\"" $FILE.proxy;
  cp $FILE.proxy $FILE;
}

##
# setting 
#
configure_network_nsswitch() {
  FILE=/etc/nsswitch.conf;
  backup_file $FILE;
  sed -i "s/dns mdns4/dns [NOTFOUND=return] mdns4/" $FILE
}

##
# export proxy variables
#
export_proxy_variables() {
  export http_proxy="http://189.8.69.36:80/"
  export https_proxy="http://189.8.69.36:80/"
  export ftp_proxy="http://189.8.69.36:80/"
  export no_proxy="localhost,127.0.0.1,.sicoob.com.br,.bancoob.com.br,.homologacao.com.br,svn.sicoob.com.br"
}

##
# configure ignore hosts gnome
#
configure_ignore_hosts_gnome() {
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '*sicoob.com.br', '*bancoob.com.br', '*bancoob.br', '*homologacao.com.br', 'jb*', 'gis*', 'sicoob*']"
  gsettings set org.gnome.system.proxy.ftp host "189.8.69.36"
  gsettings set org.gnome.system.proxy.ftp port 80
  gsettings set org.gnome.system.proxy.http host "189.8.69.36"
  gsettings set org.gnome.system.proxy.http port 80
  gsettings set org.gnome.system.proxy.https host "189.8.69.36"
  gsettings set org.gnome.system.proxy.https port 80
  gsettings set org.gnome.system.proxy mode "manual"
}

##
# configure java oracle in system
#
configure_java_oracle() {
  sudo update-alternatives --install "/usr/bin/java" "java" "/home/anderson/sisbride/sdk/jdk1.8.0_05/bin/java" 1
  sudo update-alternatives --set java /home/anderson/sisbride/sdk/jdk1.8.0_05/bin/java
}

##
# configure java oracle in browsers
#
configure_java_oracle_browser() {
  sudo mkdir -p /usr/lib/mozilla/plugins
  sudo ln -s /home/anderson/sisbride/sdk/jdk1.8.0_05/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/libnpjp2.so
  sudo mkdir -p /usr/lib/chromium-browser/plugins
  sudo ln -s /home/anderson/sisbride/sdk/jdk1.8.0_05/jre/lib/amd64/libnpjp2.so /usr/lib/chromium-browser/plugins/libnpjp2.so
}

##
# installing packages
#
install_packages() {
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install dos2unix -y
  sudo apt-get install curl -y
  sudo apt-get install vim -y
  sudo apt-get install exfat-fuse -y
  sudo apt-get install ubuntu-restricted-extras -y
  sudo apt-get install dconf-tools dconf-editor -y
  sudo apt-get install chromium-browser -y
  sudo apt-get install synaptic -y
  sudo apt-get install subversion -y
  sudo apt-get install ssh -y
  sudo apt-get install ethtool -y
  sudo apt-get install xterm -y
  sudo apt-get install p7zip-full -y
  sudo apt-get install git -y
  sudo apt-get install source-highlight -y
  sudo apt-get install ia32-libs -y
  sudo apt-get remove icedtea* -y
}

##
# other configs
#
other_configs() {
  echo "davmail_4.4.0-2198-1_all.deb"
  echo "google-chrome-stable_current_amd64.deb"
  echo "virtualbox-4.3_4.3.0-89960~Ubuntu~raring_amd64"
  echo "vagrant_1.4.1_x86_64.deb"
  echo "xmind-linux-3.4.0.201311050558_amd64.deb"
}

##
# main
#
if [ `whoami` != "root" ]; then
  echo "you need to be root to execute this script";
  exit 1;
else
  export_proxy_variables
  configure_environment
  configure_ignore_hosts_gnome
  confugure_profile
  configure_network_nsswitch
  install_packages
  configure_java_oracle
  configure_java_oracle_browser
  configure_dotfiles
  configure_bin
  other_configs
  exit 0;
fi


