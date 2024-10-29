# usage: cd_up.. <number_of_parents>
function cd_up() {
  cd $(printf "%0.0s../" $(seq 1 $1));
}

function lsprt() {

    if [ $# -ne 1 ]; then
        echo "Usage: $FUNCNAME <port>"
        return 1
    fi

    local port="$1"

    lsof -i -P | grep $port
}
