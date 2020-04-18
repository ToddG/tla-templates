------------------------------ MODULE {{cookiecutter.module_name}}  ------------------------------
EXTENDS TLC
PT == INSTANCE PT
LOCAL INSTANCE FiniteSets
LOCAL INSTANCE Integers
LOCAL INSTANCE Sequences
LOCAL INSTANCE Naturals

CONSTANT Debug                  \* if TRUE then print debug stuff
ASSUME Debug \in {TRUE, FALSE}
CONSTANT Procs                  \* set of processors
ASSUME Cardinality(Procs) > 0   \* should have 1 or more processors
CONSTANT MaxValue               \* maximum value to increment to
ASSUME MaxValue \in Nat \ {0}   \* maximum value should be in 1..Nat

\* TODO: add more constants here and initialize in the `.cfg` file

\* ---------------------------------------------------------------------------
\* Safety checks (INVARIANTS)
\* ---------------------------------------------------------------------------
\* TODO: add safety checks here


\* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\* PLUSCAL START
\* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
(*--algorithm {{cookiecutter.module_name}}

\* ---------------------------------------------------------------------------
\* variables
\* ---------------------------------------------------------------------------
variables
    proc_values = [p \in Procs |-> 0];

\* ---------------------------------------------------------------------------
\* defines (INVARIANTS)
\* ---------------------------------------------------------------------------
define
    ProcValuesNeverExceedMaxValue ==
        \A p \in Procs : ~(proc_values[p] > MaxValue)
    MaxValueIsAlwaysGreatest ==
        \A p \in Procs : PT!Max(proc_values[p], MaxValue) = MaxValue
    Invariants ==
        /\ ProcValuesNeverExceedMaxValue
        /\ MaxValueIsAlwaysGreatest
end define;

\* ---------------------------------------------------------------------------
\* macros can be called by procedures and processes
\* ---------------------------------------------------------------------------
macro increment(x) begin
    x := x + 1
end macro;

macro debug(name) begin
    if Debug then
        print("----");
        print("Name: " \o ToString(name));
        print("Self: " \o ToString(self));
        print("Procs: " \o ToString(Procs));
        print("proc_values: " \o ToString(proc_values));
    end if;
end macro;

\* ---------------------------------------------------------------------------
\* procedures can be called by processes (and can call macros)
\* ---------------------------------------------------------------------------
(* do_increment

    Increment the process local variable 'x' _and_ increment the global value
    for this proc stored in 'proc_values[proc_id]'.

    Arguments:
        x (int) : process local variable
        proc (id) : process id
*)
procedure do_increment(x, proc)
    \* procedures can have local vars, this var is not used
    variables procedure_local_y_not_used = 0;
    begin
        ProcedureLabel1:
            debug("ProcedureLabel1");
            if x < MaxValue then
                x := x + 1;
                proc_values[proc] := x;
            end if;
            goto ProcedureLabel1;
        ProcedureLabel2:
        return;
end procedure;

\* ---------------------------------------------------------------------------
\* processes
\* ---------------------------------------------------------------------------
process Proc \in Procs
    variables
        \* vars local to this processor
        proc_local_var_a = 0,
    begin
        ProcLabel1:
            while TRUE do
                call do_increment(proc_local_var_a, self);
            end while;
end process;
end algorithm;
*)
\* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\* PLUSCAL END
\* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\* BEGIN TRANSLATION
CONSTANT defaultInitValue
VARIABLES proc_values, pc, stack

(* define statement *)
ProcValuesNeverExceedMaxValue ==
    \A p \in Procs : ~(proc_values[p] > MaxValue)

VARIABLES x, proc, procedure_local_y_not_used, proc_local_var_a

vars == << proc_values, pc, stack, x, proc, procedure_local_y_not_used, 
           proc_local_var_a >>

ProcSet == (Procs)

Init == (* Global variables *)
        /\ proc_values = [p \in Procs |-> 0]
        (* Procedure do_increment *)
        /\ x = [ self \in ProcSet |-> defaultInitValue]
        /\ proc = [ self \in ProcSet |-> defaultInitValue]
        /\ procedure_local_y_not_used = [ self \in ProcSet |-> 0]
        (* Process Proc *)
        /\ proc_local_var_a = [self \in Procs |-> 0]
        /\ stack = [self \in ProcSet |-> << >>]
        /\ pc = [self \in ProcSet |-> "ProcLabel1"]

ProcedureLabel1(self) == /\ pc[self] = "ProcedureLabel1"
                         /\ IF x[self] < MaxValue
                               THEN /\ x' = [x EXCEPT ![self] = x[self] + 1]
                                    /\ proc_values' = [proc_values EXCEPT ![proc[self]] = x'[self]]
                               ELSE /\ TRUE
                                    /\ UNCHANGED << proc_values, x >>
                         /\ pc' = [pc EXCEPT ![self] = "ProcedureLabel1"]
                         /\ UNCHANGED << stack, proc, 
                                         procedure_local_y_not_used, 
                                         proc_local_var_a >>

ProcedureLabel2(self) == /\ pc[self] = "ProcedureLabel2"
                         /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc]
                         /\ procedure_local_y_not_used' = [procedure_local_y_not_used EXCEPT ![self] = Head(stack[self]).procedure_local_y_not_used]
                         /\ x' = [x EXCEPT ![self] = Head(stack[self]).x]
                         /\ proc' = [proc EXCEPT ![self] = Head(stack[self]).proc]
                         /\ stack' = [stack EXCEPT ![self] = Tail(stack[self])]
                         /\ UNCHANGED << proc_values, proc_local_var_a >>

do_increment(self) == ProcedureLabel1(self) \/ ProcedureLabel2(self)

ProcLabel1(self) == /\ pc[self] = "ProcLabel1"
                    /\ /\ proc' = [proc EXCEPT ![self] = self]
                       /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "do_increment",
                                                                pc        |->  "ProcLabel1",
                                                                procedure_local_y_not_used |->  procedure_local_y_not_used[self],
                                                                x         |->  x[self],
                                                                proc      |->  proc[self] ] >>
                                                            \o stack[self]]
                       /\ x' = [x EXCEPT ![self] = proc_local_var_a[self]]
                    /\ procedure_local_y_not_used' = [procedure_local_y_not_used EXCEPT ![self] = 0]
                    /\ pc' = [pc EXCEPT ![self] = "ProcedureLabel1"]
                    /\ UNCHANGED << proc_values, proc_local_var_a >>

Proc(self) == ProcLabel1(self)

Next == (\E self \in ProcSet: do_increment(self))
           \/ (\E self \in Procs: Proc(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION

(* Liveness checks (PROPERTIES)
    Example of "eventually this is always true..."
        Liveness == <>[](some_value = SomeCheck())
*)

=============================================================================
\* Modification History
\* Created by {{cookiecutter.author}}
