import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99NameMap115
open C99ArrayReference (Name)

abbrev Table (α : Type) := List (Name × α)

def lookup (table : Table α) (name : Name) : Option α :=
  match table with
  | [] => none
  | (key,value)::rest => if name=key then some value else lookup rest name

def put (table : Table α) (name : Name) (value : α) : Table α :=
  match table with
  | [] => [(name,value)]
  | (key,old)::rest => if key=name then (name,value)::rest else (key,old)::put rest name value

theorem lookup_put (table : Table α) (name other : Name) (value : α) :
    lookup (put table name value) other = if other=name then some value else lookup table other := by
  induction table generalizing other with
  | nil => simp [put,lookup]
  | cons head tail ih =>
      obtain ⟨key,old⟩ := head
      by_cases equal : key=name
      · subst key
        by_cases target : other=name <;> simp [put,lookup,target]
      · by_cases same : other=key <;> by_cases target : other=name
        all_goals simp_all [put,lookup]

def erase (table : Table α) (name : Name) : Table α :=
  match table with
  | [] => []
  | (key,value)::rest => if key=name then erase rest name else (key,value)::erase rest name

theorem lookup_erase (table : Table α) (name other : Name) :
    lookup (erase table name) other = if other=name then none else lookup table other := by
  induction table generalizing other with
  | nil => simp [erase,lookup]
  | cons head tail ih =>
      obtain ⟨key,value⟩ := head
      by_cases equal : key=name
      · subst key
        by_cases target : other=name <;> simp [erase,lookup,ih,target]
      · by_cases same : other=key <;> by_cases target : other=name
        all_goals simp_all [erase,lookup]

def restore (before after : Table α) : List Name → Table α
  | [] => after
  | name::rest => restore before
      (match lookup before name with | none => erase after name | some value => put after name value) rest

theorem lookup_restore (before after : Table α) (names : List Name) (other : Name) :
    lookup (restore before after names) other =
      if other∈names then lookup before other else lookup after other := by
  induction names generalizing after with
  | nil => simp [restore]
  | cons name rest ih =>
      rw [restore,ih]
      cases found : lookup before name with
      | none =>
          rw [lookup_erase]
          by_cases same : other=name
          · subst other
            simp [found]
          · by_cases member : other∈rest <;> simp [same,member]
      | some value =>
          rw [lookup_put]
          by_cases same : other=name
          · subst other
            simp [found]
          · by_cases member : other∈rest <;> simp [same,member]

end FT1536.Source3.C99NameMap115
