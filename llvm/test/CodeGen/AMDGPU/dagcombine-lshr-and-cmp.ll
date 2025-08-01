; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=amdgcn-- -stop-after=amdgpu-isel -O0 < %s | FileCheck -check-prefix=GCN %s

define i32 @divergent_lshr_and_cmp(i32 %x) {
  ; GCN-LABEL: name: divergent_lshr_and_cmp
  ; GCN: bb.0.entry:
  ; GCN-NEXT:   successors: %bb.1(0x40000000), %bb.2(0x40000000)
  ; GCN-NEXT:   liveins: $vgpr0
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN-NEXT:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 2, [[COPY]], implicit $exec
  ; GCN-NEXT:   [[V_CMP_NE_U32_e64_:%[0-9]+]]:sreg_64 = V_CMP_NE_U32_e64 killed [[V_AND_B32_e64_]], 0, implicit $exec
  ; GCN-NEXT:   [[SI_IF:%[0-9]+]]:sreg_64 = SI_IF killed [[V_CMP_NE_U32_e64_]], %bb.2, implicit-def dead $exec, implicit-def dead $scc, implicit $exec
  ; GCN-NEXT:   S_BRANCH %bb.1
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT: bb.1.out.true:
  ; GCN-NEXT:   successors: %bb.2(0x80000000)
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 2
  ; GCN-NEXT:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 killed [[S_MOV_B32_]], [[COPY]], implicit $exec
  ; GCN-NEXT:   S_BRANCH %bb.2
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT: bb.2.UnifiedReturnBlock:
  ; GCN-NEXT:   [[PHI:%[0-9]+]]:vgpr_32 = PHI [[COPY]], %bb.0, [[V_LSHLREV_B32_e64_]], %bb.1
  ; GCN-NEXT:   SI_END_CF [[SI_IF]], implicit-def dead $exec, implicit-def dead $scc, implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[PHI]]
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
entry:
  %0 = and i32 %x, 2
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %out.true, label %out.else

out.true:
  %2 = shl i32 %x, 2
  ret i32 %2

out.else:
  ret i32 %x
}

define amdgpu_kernel void @uniform_opt_lshr_and_cmp(ptr addrspace(1) %out, i32 %x) {
  ; GCN-LABEL: name: uniform_opt_lshr_and_cmp
  ; GCN: bb.0.entry:
  ; GCN-NEXT:   successors: %bb.1(0x40000000), %bb.2(0x40000000)
  ; GCN-NEXT:   liveins: $sgpr4_sgpr5
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:sgpr_64(p4) = COPY $sgpr4_sgpr5
  ; GCN-NEXT:   [[S_LOAD_DWORDX2_IMM:%[0-9]+]]:sreg_64_xexec = S_LOAD_DWORDX2_IMM [[COPY]](p4), 9, 0 :: (dereferenceable invariant load (s64) from %ir.out.kernarg.offset, align 4, addrspace 4)
  ; GCN-NEXT:   [[S_LOAD_DWORD_IMM:%[0-9]+]]:sreg_32_xm0_xexec = S_LOAD_DWORD_IMM [[COPY]](p4), 11, 0 :: (dereferenceable invariant load (s32) from %ir.x.kernarg.offset, addrspace 4)
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:sreg_64 = COPY [[S_LOAD_DWORDX2_IMM]]
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 2
  ; GCN-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 [[S_LOAD_DWORD_IMM]], killed [[S_MOV_B32_]], implicit-def dead $scc
  ; GCN-NEXT:   [[S_AND_B32_1:%[0-9]+]]:sreg_32 = S_AND_B32 2, [[S_LOAD_DWORD_IMM]], implicit-def dead $scc
  ; GCN-NEXT:   S_CMP_LG_U32 killed [[S_AND_B32_1]], 0, implicit-def $scc
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:sreg_64_xexec = COPY [[COPY2]]
  ; GCN-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN-NEXT:   S_CMP_EQ_U32 killed [[S_AND_B32_]], killed [[S_MOV_B32_1]], implicit-def $scc
  ; GCN-NEXT:   S_CBRANCH_SCC1 %bb.2, implicit $scc
  ; GCN-NEXT:   S_BRANCH %bb.1
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT: bb.1.out.true:
  ; GCN-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64 = S_MOV_B64 -1
  ; GCN-NEXT:   [[S_XOR_B64_:%[0-9]+]]:sreg_64_xexec = S_XOR_B64 [[COPY3]], killed [[S_MOV_B64_]], implicit-def dead $scc
  ; GCN-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY [[COPY1]].sub1
  ; GCN-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY [[COPY1]].sub0
  ; GCN-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 61440
  ; GCN-NEXT:   [[S_MOV_B32_3:%[0-9]+]]:sreg_32 = S_MOV_B32 -1
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE killed [[COPY5]], %subreg.sub0, killed [[COPY4]], %subreg.sub1, killed [[S_MOV_B32_3]], %subreg.sub2, killed [[S_MOV_B32_2]], %subreg.sub3
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_XOR_B64_]], implicit $exec
  ; GCN-NEXT:   BUFFER_STORE_BYTE_OFFSET killed [[V_CNDMASK_B32_e64_]], killed [[REG_SEQUENCE]], 0, 0, 0, 0, implicit $exec :: (store (s8) into %ir.out.load, addrspace 1)
  ; GCN-NEXT:   S_ENDPGM 0
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT: bb.2.out.else:
  ; GCN-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY [[COPY1]].sub1
  ; GCN-NEXT:   [[COPY7:%[0-9]+]]:sreg_32 = COPY [[COPY1]].sub0
  ; GCN-NEXT:   [[S_MOV_B32_4:%[0-9]+]]:sreg_32 = S_MOV_B32 61440
  ; GCN-NEXT:   [[S_MOV_B32_5:%[0-9]+]]:sreg_32 = S_MOV_B32 -1
  ; GCN-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE killed [[COPY7]], %subreg.sub0, killed [[COPY6]], %subreg.sub1, killed [[S_MOV_B32_5]], %subreg.sub2, killed [[S_MOV_B32_4]], %subreg.sub3
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_1:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, [[COPY3]], implicit $exec
  ; GCN-NEXT:   BUFFER_STORE_BYTE_OFFSET killed [[V_CNDMASK_B32_e64_1]], killed [[REG_SEQUENCE1]], 0, 0, 0, 0, implicit $exec :: (store (s8) into %ir.out.load, addrspace 1)
  ; GCN-NEXT:   S_ENDPGM 0
entry:
  %0 = and i32 %x, 2
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %out.true, label %out.else

out.true:
  %2 = xor i1 %1, -1
  store i1 %2, ptr addrspace(1) %out
  ret void

out.else:
  store i1 %1, ptr addrspace(1) %out
  ret void
}

