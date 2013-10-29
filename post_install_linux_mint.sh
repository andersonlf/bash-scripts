#!/bin/bash

##
# Configuracoes do proxy
# http://pac.zscaler.net/sicoob.com.br/sicoob.pac
# ['localhost', '127.0.0.0/8', '*sicoob.com.br', '*bancoob.com.br', '*bancoob.br', '*homologacao.com.br', 'jb*', 'gis*', 'sicoob*']
##

TIMESTAMP=`date +"%Y%m%d-%H%M%S"`;

##
# backup $file
#
backup_file() {
  cp $1 $1.$TIMESTAMP;
}

##
# append text parameter to file parameter
#
append_text_to_file() {
  echo $1 >> $2;
}

##
# configure bash
#
configure_bash() {
  MYUSER=$1
  FILE=/home/$MYUSER/.bashrc;
  backup_file $FILE;
  append_text_to_file "alias set-java-7='export JAVA_HOME=/home/anderson/sisbride/sdk/jdk1.7.0_45;export JRE_HOME=/home/anderson/sisbride/sdk/jdk1.7.0_45;export PATH=\$JAVA_HOME/bin:\$PATH;'" $FILE;
  append_text_to_file "alias set-java-6='export JAVA_HOME=/home/anderson/sisbride/sdk/jdk1.6.0_45;export JRE_HOME=/home/anderson/sisbride/sdk/jdk1.6.0_45;export PATH=\$JAVA_HOME/bin:\$PATH;'" $FILE;
  append_text_to_file "alias set-java-5='export JAVA_HOME=/home/anderson/sisbride/sdk/jdk1.5.0_22;export JRE_HOME=/home/anderson/sisbride/sdk/jdk1.5.0_22;export PATH=\$JAVA_HOME/bin:\$PATH;'" $FILE;
  append_text_to_file "alias ec='mvn eclipse:clean eclipse:eclipse -Dversao.source.java=1.7 -Dversao.target.java=1.7'" $FILE;
  append_text_to_file "alias io='mvn clean compile install -DskipTests'" $FILE;
  append_text_to_file "alias mkdir='mkdir -p -v'" $FILE; 
  append_text_to_file "export LESS=\"-R\"" $FILE;
  append_text_to_file "eval \"\$(lesspipe)\"" $FILE;
}

##
# configure lessfilter
#
configure_lessfilter() {
  MYUSER=$1
  FILE=/home/$MYUSER/.lessfilter;
  append_text_to_file "#!/bin/bash" $FILE;
  append_text_to_file "source-highlight -fesc -oSTDOUT -i \"$1\" 2>/dev/null" $FILE;
  chmod 755 $FILE;
}

##
# setting environment variables
#
confugure_profile() {
  FILE=/etc/profile;
  backup_file $FILE;
  append_text_to_file "export SISBRIDE_HOME=\"/home/anderson/sisbride\";" $FILE;
  append_text_to_file "export JAVA_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.7.0_45\";" $FILE;
  append_text_to_file "export JRE_HOME=\"\$SISBRIDE_HOME/sdk/jdk1.7.0_45\";" $FILE;
  append_text_to_file "export MAVEN_HOME=\"\$SISBRIDE_HOME/tools/apache-maven-3.1.1\";" $FILE;
  append_text_to_file "export ANT_HOME=\"\$SISBRIDE_HOME/tools/apache-ant-1.9.2\";" $FILE;
  append_text_to_file "export PATH=\$PATH:\$JAVA_HOME/bin:\$MAVEN_HOME/bin:\$ANT_HOME/bin:\$SISBRIDE_HOME/bin;" $FILE;
}

##
# setting 
#
configure_environment() {
  FILE=/etc/environment;
  backup_file $FILE;
  append_text_to_file "http_proxy=\"$http_proxy\"" $FILE;
  append_text_to_file "https_proxy=\"$https_proxy\"" $FILE;
  append_text_to_file "ftp_proxy=\"$ftp_proxy\"" $FILE;
  append_text_to_file "no_proxy=\"$no_proxy\"" $FILE;
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
  sudo apt-get install playonlinux -y
  sudo apt-get install xterm -y
  sudo apt-get install p7zip-full -y
  sudo apt-get install git -y
  sudo apt-get install source-highlight -y
}

##
# main
#
if [ `whoami` != "root" ]; then
  echo "you need to be root to execute this script";
  exit 1;
else 
  if [ $# -lt 1 ]; then 
    echo "usage: ./post-install.sh username";
    exit 1;
  else 
    export_proxy_variables
    #install_packages
    #configure_environment
    #confugure_profile
    #configure_network_nsswitch
    #configure_bash $1
    #configure_lessfilter $1
    exit 0;
  fi
fi


