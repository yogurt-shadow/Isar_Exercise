(* author: wzh *)
theory Exercise2_2
  imports Main

begin
(* Exer 2.6 *)
datatype 'a tree = Tip | Node "'a tree" 'a "'a tree"

(* Convert a tree to a list *)
fun contents :: "'a tree \<Rightarrow> 'a list" where
"contents Tip = []" |
"contents (Node l x r) = (contents l) @ [x] @ (contents r)"

fun sum_tree :: "nat tree \<Rightarrow> nat" where
"sum_tree Tip = 0" |
"sum_tree (Node l x r) = (sum_tree l) + x + (sum_tree r)"

theorem "sum_tree t = sum_list(contents t)"
  apply(induction t)
   apply(auto)
  done


(* Exer 2.7 *)
fun pre_order :: "'a tree \<Rightarrow> 'a list" where
"pre_order Tip = []" |
"pre_order (Node l x r) = [x] @ (pre_order l) @ (pre_order r)"

fun post_order :: "'a tree \<Rightarrow> 'a list" where
"post_order Tip = []" |
"post_order (Node l x r) = (post_order l) @ (post_order r) @ [x]"

fun mirror :: "'a tree \<Rightarrow> 'a tree" where
"mirror Tip = Tip" |
"mirror (Node l x r) = Node (mirror r) x (mirror l)"


lemma mirr: "mirror (mirror t) = t"
  apply(induction t)
   apply(auto)
  done

theorem "rev(post_order t) = pre_order(mirror  t)"
  apply(induction t)
   apply(auto)
  done


(* Exer 2.8 *)
fun intersperse :: "'a \<Rightarrow> 'a list \<Rightarrow> 'a list" where
"intersperse x [] = [x]" |
"intersperse x (y # ys) = [y] @ [x] @ (intersperse x ys)"

theorem "map f (intersperse a xs) = intersperse (f a) (map f xs)"
  apply(induction xs)
   apply(auto)
  done

(* Exer 2.9 *)
fun itadd :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
"itadd 0 x = x" |
"itadd (Suc m) n = itadd m (Suc n)"

fun add :: "nat \<Rightarrow> nat \<Rightarrow> nat" where
"add 0 m = m" |
"add (Suc(n)) m = Suc(add n m)"


(* Exer 2.10 *)
datatype tree0 = Tip | Node tree0 tree0

fun nodes :: "tree0 \<Rightarrow> nat" where
"nodes Tip = 0" |
"nodes (Node l r) = 1 + (nodes l) + (nodes r)"

fun explode :: "nat \<Rightarrow> tree0 \<Rightarrow> tree0" where
"explode 0 t = t" |
"explode (Suc n) t = explode n (Node t t)"

(* arbitrary t is used to fix t when inducting *)
theorem "nodes (explode n t) = 2^n * (nodes t) + (2^n - 1)"
  apply(induction n arbitrary: t)
   apply(auto)
  apply(simp add: algebra_simps)
  done

(* Exer 2.11 *)
datatype exp = Var | Const int | Add exp exp | Mult exp exp

fun eval :: "exp \<Rightarrow> int \<Rightarrow> int" where
"eval Var x = x" |
"eval (Const n) x = n" |
"eval (Add ex1 ex2) x = (eval ex1 x) + (eval ex2 x)" |
"eval (Mult ex1 ex2) x = (eval ex1 x) * (eval ex2 x)"

fun evalp :: "int list \<Rightarrow> int \<Rightarrow> int" where
"evalp [] y = 0" |
"evalp (x # xs) y = x + y * (evalp xs y)"

value "evalp [4, 2, -1, 3] 2"

fun sum :: "int list \<Rightarrow> int list \<Rightarrow> int list" where
"sum [] ys = ys" |
"sum xs [] = xs" |
"sum (x # xs) (y # ys) = [x + y] @ (sum xs ys)"

value "sum [4, 2, 1] [1, 4]"

fun mul :: "int list \<Rightarrow> int list \<Rightarrow> int list" where
"mul [] ys = []" |
"mul xs [] = []" |
"mul [x] (y # ys) = [x * y]  @ (mul [x] ys)" |
"mul (x # xs) ys = sum (mul [x] ys) ([0] @ (mul xs ys))"

value "mul [2] [2, 3]"
value "mul [1, 2] [2, 3]"
value "mul [1, 2, 3] [4, 5, 6]"

fun coeffs :: "exp \<Rightarrow> int list" where
"coeffs Var = [0, 1]" |
"coeffs (Const n) = [n]" |
"coeffs (Add ex1 ex2) = sum (coeffs ex1) (coeffs ex2)" |
"coeffs (Mult ex1 ex2) = mul (coeffs ex1) (coeffs ex2)"

(* prove correctness for add and mul respectively *)
lemma evalp_add[simp]: "evalp (sum xs ys) a = evalp xs a + evalp ys a"
  apply (induction rule: sum.induct)
  apply (auto simp add:Int.int_distrib)
  done

lemma evalp_mul[simp]: "evalp (mul xs ys) a = evalp xs a * evalp ys a"
  apply (induction rule: mul.induct)
  apply (auto simp add:Int.int_distrib)
  done

theorem "evalp (coeffs e) x = eval e x"
  apply(induction e)
     apply(auto)
  done

end