; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=amdgcn -mcpu=tahiti < %s | FileCheck -enable-var-scope -check-prefixes=SI %s
; RUN: llc -mtriple=amdgcn -mcpu=fiji -mattr=-flat-for-global < %s | FileCheck -enable-var-scope -check-prefixes=VI %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -mattr=+real-true16 -mattr=-flat-for-global < %s | FileCheck -enable-var-scope -check-prefixes=GFX11-TRUE16 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -mattr=-real-true16 -mattr=-flat-for-global < %s | FileCheck -enable-var-scope -check-prefixes=GFX11-FAKE16 %s

define amdgpu_kernel void @br_cc_f16(
; SI-LABEL: br_cc_f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[4:5], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s2
; SI-NEXT:    s_mov_b32 s5, s3
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cmp_nlt_f32_e32 vcc, v0, v1
; SI-NEXT:    s_cbranch_vccnz .LBB0_2
; SI-NEXT:  ; %bb.1: ; %one
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    s_branch .LBB0_3
; SI-NEXT:  .LBB0_2: ; %two
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v1
; SI-NEXT:  .LBB0_3: ; %one
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: br_cc_f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[4:5], 0x34
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s4, s2
; VI-NEXT:    s_mov_b32 s5, s3
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    s_mov_b32 s2, s6
; VI-NEXT:    s_mov_b32 s3, s7
; VI-NEXT:    v_cmp_nlt_f16_e32 vcc, v0, v1
; VI-NEXT:    s_cbranch_vccnz .LBB0_2
; VI-NEXT:  ; %bb.1: ; %one
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
; VI-NEXT:  .LBB0_2: ; %two
; VI-NEXT:    buffer_store_short v1, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: br_cc_f16:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_clause 0x1
; GFX11-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_load_b64 s[8:9], s[4:5], 0x34
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s10, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s11, s7
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s4, s2
; GFX11-TRUE16-NEXT:    s_mov_b32 s5, s3
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0 glc dlc
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    buffer_load_u16 v1, off, s[8:11], 0 glc dlc
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s2, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s3, s7
; GFX11-TRUE16-NEXT:    v_mov_b16_e32 v2.l, v0.l
; GFX11-TRUE16-NEXT:    v_mov_b16_e32 v2.h, v1.l
; GFX11-TRUE16-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-TRUE16-NEXT:    v_cmp_nlt_f16_e32 vcc_lo, v2.l, v2.h
; GFX11-TRUE16-NEXT:    s_cbranch_vccnz .LBB0_2
; GFX11-TRUE16-NEXT:  ; %bb.1: ; %one
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-TRUE16-NEXT:    s_endpgm
; GFX11-TRUE16-NEXT:  .LBB0_2: ; %two
; GFX11-TRUE16-NEXT:    buffer_store_b16 v1, off, s[0:3], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: br_cc_f16:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_clause 0x1
; GFX11-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_load_b64 s[8:9], s[4:5], 0x34
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s10, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s11, s7
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s4, s2
; GFX11-FAKE16-NEXT:    s_mov_b32 s5, s3
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0 glc dlc
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    buffer_load_u16 v1, off, s[8:11], 0 glc dlc
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s2, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s3, s7
; GFX11-FAKE16-NEXT:    v_cmp_nlt_f16_e32 vcc_lo, v0, v1
; GFX11-FAKE16-NEXT:    s_cbranch_vccnz .LBB0_2
; GFX11-FAKE16-NEXT:  ; %bb.1: ; %one
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-FAKE16-NEXT:    s_endpgm
; GFX11-FAKE16-NEXT:  .LBB0_2: ; %two
; GFX11-FAKE16-NEXT:    buffer_store_b16 v1, off, s[0:3], 0
; GFX11-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) {
entry:
  %a.val = load volatile half, ptr addrspace(1) %a
  %b.val = load volatile half, ptr addrspace(1) %b
  %fcmp = fcmp olt half %a.val, %b.val
  br i1 %fcmp, label %one, label %two

one:
  store half %a.val, ptr addrspace(1) %r
  ret void

two:
  store half %b.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @br_cc_f16_imm_a(
; SI-LABEL: br_cc_f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s2
; SI-NEXT:    s_mov_b32 s5, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cmp_nlt_f32_e32 vcc, 0.5, v0
; SI-NEXT:    s_cbranch_vccnz .LBB1_2
; SI-NEXT:  ; %bb.1: ; %one
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_mov_b32_e32 v0, 0x3800
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
; SI-NEXT:  .LBB1_2: ; %two
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: br_cc_f16_imm_a:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s4, s2
; VI-NEXT:    s_mov_b32 s5, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; VI-NEXT:    s_mov_b32 s2, s6
; VI-NEXT:    s_mov_b32 s3, s7
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cmp_nlt_f16_e32 vcc, 0.5, v0
; VI-NEXT:    s_cbranch_vccnz .LBB1_2
; VI-NEXT:  ; %bb.1: ; %one
; VI-NEXT:    v_mov_b32_e32 v0, 0x3800
; VI-NEXT:  .LBB1_2: ; %two
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: br_cc_f16_imm_a:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s4, s2
; GFX11-TRUE16-NEXT:    s_mov_b32 s5, s3
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    v_mov_b16_e32 v1.l, v0.l
; GFX11-TRUE16-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-TRUE16-NEXT:    v_cmp_nlt_f16_e32 vcc_lo, 0.5, v1.l
; GFX11-TRUE16-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX11-TRUE16-NEXT:  ; %bb.1: ; %one
; GFX11-TRUE16-NEXT:    v_mov_b32_e32 v0, 0x3800
; GFX11-TRUE16-NEXT:  .LBB1_2: ; %two
; GFX11-TRUE16-NEXT:    s_mov_b32 s2, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s3, s7
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: br_cc_f16_imm_a:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s4, s2
; GFX11-FAKE16-NEXT:    s_mov_b32 s5, s3
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    v_cmp_nlt_f16_e32 vcc_lo, 0.5, v0
; GFX11-FAKE16-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX11-FAKE16-NEXT:  ; %bb.1: ; %one
; GFX11-FAKE16-NEXT:    v_mov_b32_e32 v0, 0x3800
; GFX11-FAKE16-NEXT:  .LBB1_2: ; %two
; GFX11-FAKE16-NEXT:    s_mov_b32 s2, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s3, s7
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %b) {
entry:
  %b.val = load half, ptr addrspace(1) %b
  %fcmp = fcmp olt half 0xH3800, %b.val
  br i1 %fcmp, label %one, label %two

one:
  store half 0xH3800, ptr addrspace(1) %r
  ret void

two:
  store half %b.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @br_cc_f16_imm_b(
; SI-LABEL: br_cc_f16_imm_b:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s2
; SI-NEXT:    s_mov_b32 s5, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cmp_ngt_f32_e32 vcc, 0.5, v0
; SI-NEXT:    s_cbranch_vccnz .LBB2_2
; SI-NEXT:  ; %bb.1: ; %one
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
; SI-NEXT:  .LBB2_2: ; %two
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_mov_b32_e32 v0, 0x3800
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: br_cc_f16_imm_b:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s4, s2
; VI-NEXT:    s_mov_b32 s5, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[4:7], 0
; VI-NEXT:    s_mov_b32 s2, s6
; VI-NEXT:    s_mov_b32 s3, s7
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cmp_ngt_f16_e32 vcc, 0.5, v0
; VI-NEXT:    s_cbranch_vccnz .LBB2_2
; VI-NEXT:  ; %bb.1: ; %one
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
; VI-NEXT:  .LBB2_2: ; %two
; VI-NEXT:    v_mov_b32_e32 v0, 0x3800
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: br_cc_f16_imm_b:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s4, s2
; GFX11-TRUE16-NEXT:    s_mov_b32 s5, s3
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    v_mov_b16_e32 v1.l, v0.l
; GFX11-TRUE16-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-TRUE16-NEXT:    v_cmp_ngt_f16_e32 vcc_lo, 0.5, v1.l
; GFX11-TRUE16-NEXT:    s_cbranch_vccz .LBB2_2
; GFX11-TRUE16-NEXT:  ; %bb.1: ; %two
; GFX11-TRUE16-NEXT:    v_mov_b32_e32 v0, 0x3800
; GFX11-TRUE16-NEXT:  .LBB2_2: ; %one
; GFX11-TRUE16-NEXT:    s_mov_b32 s2, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s3, s7
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: br_cc_f16_imm_b:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s4, s2
; GFX11-FAKE16-NEXT:    s_mov_b32 s5, s3
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[4:7], 0
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    v_cmp_ngt_f16_e32 vcc_lo, 0.5, v0
; GFX11-FAKE16-NEXT:    s_cbranch_vccz .LBB2_2
; GFX11-FAKE16-NEXT:  ; %bb.1: ; %two
; GFX11-FAKE16-NEXT:    v_mov_b32_e32 v0, 0x3800
; GFX11-FAKE16-NEXT:  .LBB2_2: ; %one
; GFX11-FAKE16-NEXT:    s_mov_b32 s2, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s3, s7
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %fcmp = fcmp olt half %a.val, 0xH3800
  br i1 %fcmp, label %one, label %two

one:
  store half %a.val, ptr addrspace(1) %r
  ret void

two:
  store half 0xH3800, ptr addrspace(1) %r
  ret void
}
