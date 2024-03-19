# usage: cd_up.. <number_of_parents>
function cd_up() {
  cd $(printf "%0.0s../" $(seq 1 $1));
}
