
let add a b = a + b

let%test "testing add" =
  Alcotest.(check int) "same int" (add 2 2) 4

let%test "testing add" =
  Alcotest.(check int) "same int" (add 2 2) 4
