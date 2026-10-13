import ExprStack020E
import ExprMeter020E
import ExprBackend020E
import ControlStack020E
import ControlSpace020E
import SyntaxTape020E
import SyntaxCells020E
import SyntaxLegal020E
import CopyBank020E
import ControlMeter020E
import PublicDriver020E
import DriverCertificate020E
import CopyLoop020E
import CompilerAssociation020E
import ExprCompileBudget020E
import ProgramResources020E
import ReachableExpr020E

/- Author audit; full physical-resource claim remains OPEN. -/
#check FT1536.S05.ExprStack020E.append
#print axioms FT1536.S05.ExprStack020E.append
#check FT1536.S05.ExprStack020E.correct
#print axioms FT1536.S05.ExprStack020E.correct
#check FT1536.S05.ExprStack020E.length
#print axioms FT1536.S05.ExprStack020E.length
#check FT1536.S05.ExprStack020E.nodes_cost
#print axioms FT1536.S05.ExprStack020E.nodes_cost
#check FT1536.S05.ExprMeter020E.step_growth
#print axioms FT1536.S05.ExprMeter020E.step_growth
#check FT1536.S05.ExprMeter020E.answer_eq
#print axioms FT1536.S05.ExprMeter020E.answer_eq
#check FT1536.S05.ExprMeter020E.resource_bounds
#print axioms FT1536.S05.ExprMeter020E.resource_bounds
#check FT1536.S05.ExprMeter020E.compiled
#print axioms FT1536.S05.ExprMeter020E.compiled
#check FT1536.S05.ExprBackend020E.value_eq
#print axioms FT1536.S05.ExprBackend020E.value_eq
#check FT1536.S05.ExprBackend020E.atom_eq
#print axioms FT1536.S05.ExprBackend020E.atom_eq
#check FT1536.S05.ControlStack020E.work_positive
#print axioms FT1536.S05.ControlStack020E.work_positive
#check FT1536.S05.ControlStack020E.decreases
#print axioms FT1536.S05.ControlStack020E.decreases
#check FT1536.S05.ControlStack020E.preserves
#print axioms FT1536.S05.ControlStack020E.preserves
#check FT1536.S05.ControlStack020E.correct
#print axioms FT1536.S05.ControlStack020E.correct
#check FT1536.S05.ControlStack020E.singleton
#print axioms FT1536.S05.ControlStack020E.singleton
#check FT1536.S05.ControlSpace020E.nodes_le_space
#print axioms FT1536.S05.ControlSpace020E.nodes_le_space
#check FT1536.S05.ControlSpace020E.footprint_le
#print axioms FT1536.S05.ControlSpace020E.footprint_le
#check FT1536.S05.ControlSpace020E.next_reserve
#print axioms FT1536.S05.ControlSpace020E.next_reserve
#check FT1536.S05.ControlSpace020E.transition_footprint
#print axioms FT1536.S05.ControlSpace020E.transition_footprint
#check FT1536.S05.ControlSpace020E.work_le_bound
#print axioms FT1536.S05.ControlSpace020E.work_le_bound
#check FT1536.S05.SyntaxTape020E.parse_append
#print axioms FT1536.S05.SyntaxTape020E.parse_append
#check FT1536.S05.SyntaxTape020E.expression_roundtrip
#print axioms FT1536.S05.SyntaxTape020E.expression_roundtrip
#check FT1536.S05.SyntaxTape020E.atomic_roundtrip
#print axioms FT1536.S05.SyntaxTape020E.atomic_roundtrip
#check FT1536.S05.SyntaxTape020E.program_roundtrip
#print axioms FT1536.S05.SyntaxTape020E.program_roundtrip
#check FT1536.S05.SyntaxTape020E.expression_length
#print axioms FT1536.S05.SyntaxTape020E.expression_length
#check FT1536.S05.SyntaxTape020E.atomic_length
#print axioms FT1536.S05.SyntaxTape020E.atomic_length
#check FT1536.S05.SyntaxTape020E.program_length
#print axioms FT1536.S05.SyntaxTape020E.program_length
#check FT1536.S05.SyntaxTape020E.program_injective
#print axioms FT1536.S05.SyntaxTape020E.program_injective
#check FT1536.S05.SyntaxCells020E.reg_roundtrip
#print axioms FT1536.S05.SyntaxCells020E.reg_roundtrip
#check FT1536.S05.SyntaxCells020E.op_roundtrip
#print axioms FT1536.S05.SyntaxCells020E.op_roundtrip
#check FT1536.S05.SyntaxCells020E.roundtrip
#print axioms FT1536.S05.SyntaxCells020E.roundtrip
#check FT1536.S05.SyntaxCells020E.injective_on_legal
#print axioms FT1536.S05.SyntaxCells020E.injective_on_legal
#check FT1536.S05.SyntaxLegal020E.all_append
#print axioms FT1536.S05.SyntaxLegal020E.all_append
#check FT1536.S05.SyntaxLegal020E.expr_legal
#print axioms FT1536.S05.SyntaxLegal020E.expr_legal
#check FT1536.S05.SyntaxLegal020E.atom_legal
#print axioms FT1536.S05.SyntaxLegal020E.atom_legal
#check FT1536.S05.SyntaxLegal020E.code_legal
#print axioms FT1536.S05.SyntaxLegal020E.code_legal
#check FT1536.S05.SyntaxLegal020E.next_legal
#print axioms FT1536.S05.SyntaxLegal020E.next_legal
#check FT1536.S05.SyntaxLegal020E.decode_map
#print axioms FT1536.S05.SyntaxLegal020E.decode_map
#check FT1536.S05.CopyBank020E.cell
#print axioms FT1536.S05.CopyBank020E.cell
#check FT1536.S05.CopyBank020E.complete
#print axioms FT1536.S05.CopyBank020E.complete
#check FT1536.S05.CopyBank020E.transfers_exact
#print axioms FT1536.S05.CopyBank020E.transfers_exact
#check FT1536.S05.CopyBank020E.complete_price
#print axioms FT1536.S05.CopyBank020E.complete_price
#check FT1536.S05.ControlMeter020E.answer_eq
#print axioms FT1536.S05.ControlMeter020E.answer_eq
#check FT1536.S05.ControlMeter020E.bounds
#print axioms FT1536.S05.ControlMeter020E.bounds
#check FT1536.S05.ControlMeter020E.correct_with_peak
#print axioms FT1536.S05.ControlMeter020E.correct_with_peak
#check FT1536.S05.ControlMeter020E.reachable_resources
#print axioms FT1536.S05.ControlMeter020E.reachable_resources
#check FT1536.S05.PublicDriver020E.input_eq
#print axioms FT1536.S05.PublicDriver020E.input_eq
#check FT1536.S05.PublicDriver020E.reset_eq
#print axioms FT1536.S05.PublicDriver020E.reset_eq
#check FT1536.S05.PublicDriver020E.transfer_eq
#print axioms FT1536.S05.PublicDriver020E.transfer_eq
#check FT1536.S05.PublicDriver020E.execute_eq
#print axioms FT1536.S05.PublicDriver020E.execute_eq
#check FT1536.S05.PublicDriver020E.run_eq
#print axioms FT1536.S05.PublicDriver020E.run_eq
#check FT1536.S05.PublicDriver020E.totalize_eq
#print axioms FT1536.S05.PublicDriver020E.totalize_eq
#check FT1536.S05.PublicDriver020E.code_eq
#print axioms FT1536.S05.PublicDriver020E.code_eq
#check FT1536.S05.PublicDriver020E.law_eq
#print axioms FT1536.S05.PublicDriver020E.law_eq
#check FT1536.S05.PublicDriver020E.phase_price
#print axioms FT1536.S05.PublicDriver020E.phase_price
#check FT1536.S05.PublicDriver020E.transfer_price
#print axioms FT1536.S05.PublicDriver020E.transfer_price
#check FT1536.S05.DriverCertificate020E.all_h_ac
#print axioms FT1536.S05.DriverCertificate020E.all_h_ac
#check FT1536.S05.DriverCertificate020E.certificate
#print axioms FT1536.S05.DriverCertificate020E.certificate
#check FT1536.S05.DriverCertificate020E.same_key_law
#print axioms FT1536.S05.DriverCertificate020E.same_key_law
#check FT1536.S05.CopyLoop020E.run_prefix
#print axioms FT1536.S05.CopyLoop020E.run_prefix
#check FT1536.S05.CopyLoop020E.complete
#print axioms FT1536.S05.CopyLoop020E.complete
#check FT1536.S05.CopyLoop020E.cursor_bound
#print axioms FT1536.S05.CopyLoop020E.cursor_bound
#check FT1536.S05.CompilerAssociation020E.bin_shape
#print axioms FT1536.S05.CompilerAssociation020E.bin_shape
#check FT1536.S05.ExprCompileBudget020E.nodes_positive
#print axioms FT1536.S05.ExprCompileBudget020E.nodes_positive
#check FT1536.S05.ExprCompileBudget020E.allocations_bound
#print axioms FT1536.S05.ExprCompileBudget020E.allocations_bound
#check FT1536.S05.ExprCompileBudget020E.call_depth_bound
#print axioms FT1536.S05.ExprCompileBudget020E.call_depth_bound
#check FT1536.S05.ExprCompileBudget020E.nested_size
#print axioms FT1536.S05.ExprCompileBudget020E.nested_size
#check FT1536.S05.ExprCompileBudget020E.unbounded_expression_work
#print axioms FT1536.S05.ExprCompileBudget020E.unbounded_expression_work
#check FT1536.S05.ProgramResources020E.cap_value
#print axioms FT1536.S05.ProgramResources020E.cap_value
#check FT1536.S05.ProgramResources020E.space_bound
#print axioms FT1536.S05.ProgramResources020E.space_bound
#check FT1536.S05.ProgramResources020E.legal
#print axioms FT1536.S05.ProgramResources020E.legal
#check FT1536.S05.ProgramResources020E.reachable
#print axioms FT1536.S05.ProgramResources020E.reachable
#check FT1536.S05.ProgramResources020E.measured_bounds
#print axioms FT1536.S05.ProgramResources020E.measured_bounds
#check FT1536.S05.ProgramResources020E.syntax_length
#print axioms FT1536.S05.ProgramResources020E.syntax_length
#check FT1536.S05.ProgramResources020E.reachable_codec
#print axioms FT1536.S05.ProgramResources020E.reachable_codec
#check FT1536.S05.ReachableExpr020E.local_bound
#print axioms FT1536.S05.ReachableExpr020E.local_bound
#check FT1536.S05.ReachableExpr020E.next_bound
#print axioms FT1536.S05.ReachableExpr020E.next_bound
#check FT1536.S05.ReachableExpr020E.program_bound
#print axioms FT1536.S05.ReachableExpr020E.program_bound
#check FT1536.S05.ReachableExpr020E.reachable
#print axioms FT1536.S05.ReachableExpr020E.reachable
#check FT1536.S05.ReachableExpr020E.expression_resources
#print axioms FT1536.S05.ReachableExpr020E.expression_resources
