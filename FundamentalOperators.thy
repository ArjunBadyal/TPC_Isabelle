theory "FundamentalOperators"
	imports "Axiomatic_CyPhyCircus.Ax_CyPhyCircus"
begin

(*Before we define a process, we need a channel which the process can draw events from. A channel becomes an event when enough values have been supplied to complete it (See appendix B.4). In this instance up and down are of type unit i.e. they don't need values, therefore they are events. *)
chantype Chans =
	up :: unit
	down :: unit

(*Prefixing \<rightarrow> *)
definition P :: "Chans cyphyprocess" where
	"P = up \<rightarrow> down \<rightarrow> up \<rightarrow> down \<rightarrow> Stop"

(* Recursion: use the recursive command to define P1 as a least fixed point *)
recursive P1 :: "Chans cyphyprocess" where
	"P1 = up \<rightarrow> down \<rightarrow> P1"

recursive P2 :: "Chans cyphyprocess" where
	"P2 = up \<rightarrow> down \<rightarrow> up \<rightarrow> down \<rightarrow> P2"

(* Mutual recursion: requires recursive as well*)
recursive P_u :: "Chans cyphyprocess" and P_d :: "Chans cyphyprocess" where
	"P_u = up \<rightarrow> P_d"|
	"P_d = down \<rightarrow> P_u"

(* mu recursion: warning mu is a GFP not a LFP! *) 
definition P2 :: "Chans cyphyprocess" where
	"P2 = up \<rightarrow> (\<mu> p. down \<rightarrow> up \<rightarrow> p)"

(* Guarded alternative: we can't use guarded alernative in aximoatic cyphycircus so instead we use external choice \<box> which is equivalent  *)
definition UandD :: "Chans cyphyprocess" where
	"UandD = (up \<rightarrow> down \<rightarrow> STOP \<box> down \<rightarrow> up \<rightarrow> STOP)"

recursive P :: "Chans cyphyprocess" and Q :: "Chans cyphyprocess" where
	"P = (a \<rightarrow> P) \<box> b \<rightarrow> Q)" |
	"Q = (a \<rightarrow> P \<box> b \<rightarrow> STOP)"
(* Infinite mutual recursion: TODO*)
recursive Count :: "nat \<Rightarrow> chan cyphyprocess" where
"Count(n: Nat) = (if n = 0
		then up \<rightarrow> Count(1)
		else up \<rightarrow> Count(n+1) \<box> down \<rightarrow> Count(n-1)"

(*Prefix choice: ?x : A -> P(x). Define in a locale so names don't conflict with the above. *)
locale PrefixChoice =
	fixes A :: "Chans set"
	and P :: "Chans \<Rightarrow> Chans cyphyprocess"
begin
definition PrefixChoice :: "Chans cyphyprocess" where
	"cMprefix A (\<lambda>x. P x)"

end

end









