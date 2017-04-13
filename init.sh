einfo() {
  printf "\e[%dm*\e[0m %s\n" 32 "$@"
}
eerror() {
  printf "\e[%dm*\e[0m %s\n" 31 "$@"
}

ZULU7="zulu7.17.0.5-jdk7.0.131"
ZULU8="zulu8.20.0.5-jdk8.0.121"
ZULU9="zulu9.0.0.11-ea-jdk9.0.0"

install_zulu7() {
  mkdir -p "${HOME}/zulu" || return $?
  ZULU="${ZULU:-$ZULU7}"
  if [[ ! -f "${HOME}/zulu/bin/java" ]]; then
    einfo "Downloading $ZULU"
    curl -fsSLo "/tmp/zulu.tar.gz" "http://cdn.azul.com/zulu/bin/${ZULU}-linux_x64.tar.gz" || return $?
    einfo "Unpacking $ZULU"
    tar -C "${HOME}/zulu" --strip-components=1 -xf "/tmp/zulu.tar.gz" || return $?
  fi
  export PATH="${HOME}/zulu/bin:${PATH}"
  export JAVA_HOME="${HOME}/zulu"
}

install_zulu8() {
  mkdir -p "${HOME}/zulu" || return $?
  ZULU="${ZULU:-$ZULU8}"
  if [[ ! -f "${HOME}/zulu/bin/java" ]]; then
    einfo "Downloading $ZULU"
    curl -fsSLo "/tmp/zulu.tar.gz" "http://cdn.azul.com/zulu/bin/${ZULU}-linux_x64.tar.gz" || return $?
    einfo "Unpacking $ZULU"
    tar -C "${HOME}/zulu" --strip-components=1 -xf "/tmp/zulu.tar.gz" || return $?
  fi
  export PATH="${HOME}/zulu/bin:${PATH}"
  export JAVA_HOME="${HOME}/zulu"
}

install_zulu9() {
  mkdir -p "${HOME}/zulu" || return $?
  ZULU="${ZULU:-$ZULU9}"
  if [[ ! -f "${HOME}/zulu/bin/java" ]]; then
    einfo "Downloading $ZULU"
    curl -fsSLo "/tmp/zulu.tar.gz" "http://cdn.azul.com/zulu-pre/bin/${ZULU}-linux_x64.tar.gz" || return $?
    einfo "Unpacking $ZULU"
    tar -C "${HOME}/zulu" --strip-components=1 -xf "/tmp/zulu.tar.gz" || return $?
  fi
  export PATH="${HOME}/zulu/bin:${PATH}"
  export JAVA_HOME="${HOME}/zulu"
}

install_jdk() {
  einfo "install_jdk $@"
  case "$1" in
    oraclejdk8|openjdk7)
      jdk_switcher use "$1" ;
      return $?             ;
      ;;
    zulu7)
      set -x        ;
      install_zulu7 ;
      set +x        ;
      return $?     ;
      ;;
    zulu8)
      set -x        ;
      install_zulu8 ;
      set +x        ;
      return $?     ;
      ;;
    zulu9)
      set -x        ;
      install_zulu9 ;
      set +x        ;
      return $?     ;
      ;;
    *)
      eerror "Unknown target $1"
      return 1;
      ;;
  esac
}

install_boot() {
  einfo "install_boot $@"
  set -x
  if [[ ! -f ./boot ]]; then
    curl -fsSLo boot "https://github.com/boot-clj/boot-bin/releases/download/${BOOT_SH_VERSION:-2.5.2}/boot.sh" || return $?
    chmod 755 boot || return $?
  fi
  set +x
}

setup_boot_env() {
  set -x
  export BOOT_VERSION="${BOOT_VERSION:-2.7.1}"
  export BOOT_JVM_OPTIONS="-Xmx4g -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none -XX:+CMSClassUnloadingEnabled"
  set +x
}
