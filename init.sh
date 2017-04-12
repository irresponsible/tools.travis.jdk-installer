einfo() {
  printf "\e[%dm*\e[0m %s\n" 32 "$@"
}
eerror() {
  printf "\e[%dm*\e[0m %s\n" 31 "$@"
}

install_zulu8() {
  if [[ ! -v ZULU ]]; then
    error "ZULU not set"
    return 1;
  fi
  mkdir -p "${HOME}/zulu" || return $?
  if [[ ! -f "${HOME}/zulu/bin/java" ]]; then
    einfo "Downloading $ZULU"
    curl -fsSLo "/tmp/zulu.tar.gz" "http://cdn.azul.com/zulu/bin/${ZULU}-linux_x64.tar.gz" || return $?
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
    zulu8)
      set -x        ;
      install_zulu8 ;
      set +x        ;
      return $?     ;
      ;;
    *)
      eerror "Unknown target $1"
      return 1;
      ;;
  esac
}
