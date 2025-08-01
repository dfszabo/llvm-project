; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn -mcpu=tahiti -o - < %s | FileCheck %s --check-prefixes=GFX,GFX6
; RUN: llc -global-isel -mtriple=amdgcn -mcpu=fiji -o - < %s | FileCheck %s --check-prefixes=GFX,GFX8
; RUN: llc -global-isel -mtriple=amdgcn -mcpu=gfx1010 -o - < %s | FileCheck %s --check-prefixes=GFX,GFX10

declare i16 @llvm.abs.i16(i16, i1)
declare i32 @llvm.abs.i32(i32, i1)
declare i64 @llvm.abs.i64(i64, i1)
declare <2 x i8> @llvm.abs.v2i8(<2 x i8>, i1)
declare <3 x i8> @llvm.abs.v3i8(<3 x i8>, i1)
declare <2 x i16> @llvm.abs.v2i16(<2 x i16>, i1)
declare <3 x i16> @llvm.abs.v3i16(<3 x i16>, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)

define amdgpu_cs i16 @abs_sgpr_i16(i16 inreg %arg) {
; GFX-LABEL: abs_sgpr_i16:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_sext_i32_i16 s0, s0
; GFX-NEXT:    s_abs_i32 s0, s0
; GFX-NEXT:    ; return to shader part epilog
  %res = call i16 @llvm.abs.i16(i16 %arg, i1 false)
  ret i16 %res
}

define amdgpu_cs i32 @abs_sgpr_i32(i32 inreg %arg) {
; GFX-LABEL: abs_sgpr_i32:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_abs_i32 s0, s0
; GFX-NEXT:    ; return to shader part epilog
  %res = call i32 @llvm.abs.i32(i32 %arg, i1 false)
  ret i32 %res
}

define amdgpu_cs i64 @abs_sgpr_i64(i64 inreg %arg) {
; GFX-LABEL: abs_sgpr_i64:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_ashr_i32 s2, s1, 31
; GFX-NEXT:    s_add_u32 s0, s0, s2
; GFX-NEXT:    s_mov_b32 s3, s2
; GFX-NEXT:    s_addc_u32 s1, s1, s2
; GFX-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX-NEXT:    ; return to shader part epilog
  %res = call i64 @llvm.abs.i64(i64 %arg, i1 false)
  ret i64 %res
}

define amdgpu_cs <4 x i32> @abs_sgpr_v4i32(<4 x i32> inreg %arg) {
; GFX-LABEL: abs_sgpr_v4i32:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_abs_i32 s0, s0
; GFX-NEXT:    s_abs_i32 s1, s1
; GFX-NEXT:    s_abs_i32 s2, s2
; GFX-NEXT:    s_abs_i32 s3, s3
; GFX-NEXT:    ; return to shader part epilog
  %res = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %arg, i1 false)
  ret <4 x i32> %res
}

define amdgpu_cs i16 @abs_vgpr_i16(i16 %arg) {
; GFX6-LABEL: abs_vgpr_i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, 0, v0
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v1
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_sub_u16_e32 v1, 0, v0
; GFX8-NEXT:    v_max_i16_e32 v0, v0, v1
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_sub_nc_u16 v1, 0, v0
; GFX10-NEXT:    v_max_i16 v0, v0, v1
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %res = call i16 @llvm.abs.i16(i16 %arg, i1 false)
  ret i16 %res
}

define amdgpu_cs i32 @abs_vgpr_i32(i32 %arg) {
; GFX6-LABEL: abs_vgpr_i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, 0, v0
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v1
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_sub_u32_e32 v1, vcc, 0, v0
; GFX8-NEXT:    v_max_i32_e32 v0, v0, v1
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_sub_nc_u32_e32 v1, 0, v0
; GFX10-NEXT:    v_max_i32_e32 v0, v0, v1
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %res = call i32 @llvm.abs.i32(i32 %arg, i1 false)
  ret i32 %res
}

define amdgpu_cs i64 @abs_vgpr_i64(i64 %arg) {
; GFX6-LABEL: abs_vgpr_i64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_ashrrev_i32_e32 v2, 31, v1
; GFX6-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; GFX6-NEXT:    v_addc_u32_e32 v1, vcc, v1, v2, vcc
; GFX6-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX6-NEXT:    v_xor_b32_e32 v1, v1, v2
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_ashrrev_i32_e32 v2, 31, v1
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, v0, v2
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, v1, v2, vcc
; GFX8-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX8-NEXT:    v_xor_b32_e32 v1, v1, v2
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_ashrrev_i32_e32 v2, 31, v1
; GFX10-NEXT:    v_add_co_u32 v0, vcc_lo, v0, v2
; GFX10-NEXT:    v_add_co_ci_u32_e32 v1, vcc_lo, v1, v2, vcc_lo
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX10-NEXT:    v_xor_b32_e32 v1, v1, v2
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %res = call i64 @llvm.abs.i64(i64 %arg, i1 false)
  ret i64 %res
}

define amdgpu_cs <4 x i32> @abs_vgpr_v4i32(<4 x i32> %arg) {
; GFX6-LABEL: abs_vgpr_v4i32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 0, v0
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v4
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 0, v1
; GFX6-NEXT:    v_max_i32_e32 v1, v1, v4
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 0, v2
; GFX6-NEXT:    v_max_i32_e32 v2, v2, v4
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 0, v3
; GFX6-NEXT:    v_max_i32_e32 v3, v3, v4
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    v_readfirstlane_b32 s2, v2
; GFX6-NEXT:    v_readfirstlane_b32 s3, v3
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_v4i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_sub_u32_e32 v4, vcc, 0, v0
; GFX8-NEXT:    v_max_i32_e32 v0, v0, v4
; GFX8-NEXT:    v_sub_u32_e32 v4, vcc, 0, v1
; GFX8-NEXT:    v_max_i32_e32 v1, v1, v4
; GFX8-NEXT:    v_sub_u32_e32 v4, vcc, 0, v2
; GFX8-NEXT:    v_max_i32_e32 v2, v2, v4
; GFX8-NEXT:    v_sub_u32_e32 v4, vcc, 0, v3
; GFX8-NEXT:    v_max_i32_e32 v3, v3, v4
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    v_readfirstlane_b32 s2, v2
; GFX8-NEXT:    v_readfirstlane_b32 s3, v3
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_v4i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_sub_nc_u32_e32 v4, 0, v0
; GFX10-NEXT:    v_sub_nc_u32_e32 v5, 0, v1
; GFX10-NEXT:    v_sub_nc_u32_e32 v6, 0, v2
; GFX10-NEXT:    v_sub_nc_u32_e32 v7, 0, v3
; GFX10-NEXT:    v_max_i32_e32 v0, v0, v4
; GFX10-NEXT:    v_max_i32_e32 v1, v1, v5
; GFX10-NEXT:    v_max_i32_e32 v2, v2, v6
; GFX10-NEXT:    v_max_i32_e32 v3, v3, v7
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    v_readfirstlane_b32 s2, v2
; GFX10-NEXT:    v_readfirstlane_b32 s3, v3
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %arg, i1 false)
  ret <4 x i32> %res
}

define amdgpu_cs <2 x i8> @abs_sgpr_v2i8(<2 x i8> inreg %arg) {
; GFX-LABEL: abs_sgpr_v2i8:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_sext_i32_i8 s0, s0
; GFX-NEXT:    s_sext_i32_i8 s1, s1
; GFX-NEXT:    s_abs_i32 s0, s0
; GFX-NEXT:    s_abs_i32 s1, s1
; GFX-NEXT:    ; return to shader part epilog
  %res = call <2 x i8> @llvm.abs.v2i8(<2 x i8> %arg, i1 false)
  ret <2 x i8> %res
}

define amdgpu_cs <2 x i8> @abs_vgpr_v2i8(<2 x i8> %arg) {
; GFX6-LABEL: abs_vgpr_v2i8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 0, v0
; GFX6-NEXT:    v_bfe_i32 v1, v1, 0, 8
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v2
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 0, v1
; GFX6-NEXT:    v_max_i32_e32 v1, v1, v2
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_v2i8:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v2, 0
; GFX8-NEXT:    v_sub_u16_sdwa v3, v2, sext(v0) dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX8-NEXT:    v_sub_u16_sdwa v2, v2, sext(v1) dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX8-NEXT:    v_max_i16_sdwa v0, sext(v0), v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
; GFX8-NEXT:    v_max_i16_sdwa v1, sext(v1), v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_v2i8:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX10-NEXT:    v_bfe_i32 v1, v1, 0, 8
; GFX10-NEXT:    v_sub_nc_u16 v2, 0, v0
; GFX10-NEXT:    v_sub_nc_u16 v3, 0, v1
; GFX10-NEXT:    v_max_i16 v0, v0, v2
; GFX10-NEXT:    v_max_i16 v1, v1, v3
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <2 x i8> @llvm.abs.v2i8(<2 x i8> %arg, i1 false)
  ret <2 x i8> %res
}

define amdgpu_cs <3 x i8> @abs_sgpr_v3i8(<3 x i8> inreg %arg) {
; GFX-LABEL: abs_sgpr_v3i8:
; GFX:       ; %bb.0:
; GFX-NEXT:    s_sext_i32_i8 s0, s0
; GFX-NEXT:    s_sext_i32_i8 s1, s1
; GFX-NEXT:    s_sext_i32_i8 s2, s2
; GFX-NEXT:    s_abs_i32 s0, s0
; GFX-NEXT:    s_abs_i32 s1, s1
; GFX-NEXT:    s_abs_i32 s2, s2
; GFX-NEXT:    ; return to shader part epilog
  %res = call <3 x i8> @llvm.abs.v3i8(<3 x i8> %arg, i1 false)
  ret <3 x i8> %res
}

define amdgpu_cs <3 x i8> @abs_vgpr_v3i8(<3 x i8>  %arg) {
; GFX6-LABEL: abs_vgpr_v3i8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v0
; GFX6-NEXT:    v_bfe_i32 v1, v1, 0, 8
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v3
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v1
; GFX6-NEXT:    v_bfe_i32 v2, v2, 0, 8
; GFX6-NEXT:    v_max_i32_e32 v1, v1, v3
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v2
; GFX6-NEXT:    v_max_i32_e32 v2, v2, v3
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    v_readfirstlane_b32 s2, v2
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_v3i8:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v3, 0
; GFX8-NEXT:    v_sub_u16_sdwa v4, v3, sext(v0) dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX8-NEXT:    v_max_i16_sdwa v0, sext(v0), v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
; GFX8-NEXT:    v_sub_u16_sdwa v4, v3, sext(v1) dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX8-NEXT:    v_sub_u16_sdwa v3, v3, sext(v2) dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX8-NEXT:    v_max_i16_sdwa v1, sext(v1), v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
; GFX8-NEXT:    v_max_i16_sdwa v2, sext(v2), v3 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    v_readfirstlane_b32 s2, v2
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_v3i8:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX10-NEXT:    v_bfe_i32 v1, v1, 0, 8
; GFX10-NEXT:    v_bfe_i32 v2, v2, 0, 8
; GFX10-NEXT:    v_sub_nc_u16 v3, 0, v0
; GFX10-NEXT:    v_sub_nc_u16 v4, 0, v1
; GFX10-NEXT:    v_sub_nc_u16 v5, 0, v2
; GFX10-NEXT:    v_max_i16 v0, v0, v3
; GFX10-NEXT:    v_max_i16 v1, v1, v4
; GFX10-NEXT:    v_max_i16 v2, v2, v5
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    v_readfirstlane_b32 s2, v2
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <3 x i8> @llvm.abs.v3i8(<3 x i8> %arg, i1 false)
  ret <3 x i8> %res
}

define amdgpu_cs <2 x i16> @abs_sgpr_v2i16(<2 x i16> inreg %arg) {
; GFX6-LABEL: abs_sgpr_v2i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_sext_i32_i16 s0, s0
; GFX6-NEXT:    s_sext_i32_i16 s1, s1
; GFX6-NEXT:    s_abs_i32 s0, s0
; GFX6-NEXT:    s_abs_i32 s1, s1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_sgpr_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_lshr_b32 s1, s0, 16
; GFX8-NEXT:    s_sext_i32_i16 s1, s1
; GFX8-NEXT:    s_sext_i32_i16 s0, s0
; GFX8-NEXT:    s_abs_i32 s1, s1
; GFX8-NEXT:    s_abs_i32 s0, s0
; GFX8-NEXT:    s_and_b32 s1, 0xffff, s1
; GFX8-NEXT:    s_and_b32 s0, 0xffff, s0
; GFX8-NEXT:    s_lshl_b32 s1, s1, 16
; GFX8-NEXT:    s_or_b32 s0, s0, s1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_sgpr_v2i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_sext_i32_i16 s1, s0
; GFX10-NEXT:    s_ashr_i32 s0, s0, 16
; GFX10-NEXT:    s_abs_i32 s1, s1
; GFX10-NEXT:    s_abs_i32 s0, s0
; GFX10-NEXT:    s_pack_ll_b32_b16 s0, s1, s0
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <2 x i16> @llvm.abs.v2i16(<2 x i16> %arg, i1 false)
  ret <2 x i16> %res
}

define amdgpu_cs <2 x i16> @abs_vgpr_v2i16(<2 x i16> %arg) {
; GFX6-LABEL: abs_vgpr_v2i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 0, v0
; GFX6-NEXT:    v_bfe_i32 v1, v1, 0, 16
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v2
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 0, v1
; GFX6-NEXT:    v_max_i32_e32 v1, v1, v2
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v2, 0
; GFX8-NEXT:    v_sub_u16_e32 v1, 0, v0
; GFX8-NEXT:    v_sub_u16_sdwa v2, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_1
; GFX8-NEXT:    v_max_i16_e32 v1, v0, v1
; GFX8-NEXT:    v_max_i16_sdwa v0, v0, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_v2i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_pk_sub_i16 v1, 0, v0
; GFX10-NEXT:    v_pk_max_i16 v0, v0, v1
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <2 x i16> @llvm.abs.v2i16(<2 x i16> %arg, i1 false)
  ret <2 x i16> %res
}

define amdgpu_cs <3 x i16> @abs_sgpr_v3i16(<3 x i16> inreg %arg) {
; GFX6-LABEL: abs_sgpr_v3i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_sext_i32_i16 s0, s0
; GFX6-NEXT:    s_sext_i32_i16 s1, s1
; GFX6-NEXT:    s_sext_i32_i16 s2, s2
; GFX6-NEXT:    s_abs_i32 s0, s0
; GFX6-NEXT:    s_abs_i32 s1, s1
; GFX6-NEXT:    s_abs_i32 s2, s2
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_sgpr_v3i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_lshr_b32 s2, s0, 16
; GFX8-NEXT:    s_sext_i32_i16 s2, s2
; GFX8-NEXT:    s_sext_i32_i16 s0, s0
; GFX8-NEXT:    s_abs_i32 s2, s2
; GFX8-NEXT:    s_abs_i32 s0, s0
; GFX8-NEXT:    s_sext_i32_i16 s1, s1
; GFX8-NEXT:    s_and_b32 s2, 0xffff, s2
; GFX8-NEXT:    s_abs_i32 s1, s1
; GFX8-NEXT:    s_and_b32 s0, 0xffff, s0
; GFX8-NEXT:    s_lshl_b32 s2, s2, 16
; GFX8-NEXT:    s_or_b32 s0, s0, s2
; GFX8-NEXT:    s_and_b32 s1, 0xffff, s1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_sgpr_v3i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_sext_i32_i16 s2, s0
; GFX10-NEXT:    s_ashr_i32 s0, s0, 16
; GFX10-NEXT:    s_abs_i32 s2, s2
; GFX10-NEXT:    s_abs_i32 s0, s0
; GFX10-NEXT:    s_sext_i32_i16 s1, s1
; GFX10-NEXT:    s_pack_ll_b32_b16 s0, s2, s0
; GFX10-NEXT:    s_abs_i32 s1, s1
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <3 x i16> @llvm.abs.v3i16(<3 x i16> %arg, i1 false)
  ret <3 x i16> %res
}

define amdgpu_cs <3 x i16> @abs_vgpr_v3i16(<3 x i16> %arg) {
; GFX6-LABEL: abs_vgpr_v3i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v0
; GFX6-NEXT:    v_bfe_i32 v1, v1, 0, 16
; GFX6-NEXT:    v_max_i32_e32 v0, v0, v3
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v1
; GFX6-NEXT:    v_bfe_i32 v2, v2, 0, 16
; GFX6-NEXT:    v_max_i32_e32 v1, v1, v3
; GFX6-NEXT:    v_sub_i32_e32 v3, vcc, 0, v2
; GFX6-NEXT:    v_max_i32_e32 v2, v2, v3
; GFX6-NEXT:    v_readfirstlane_b32 s0, v0
; GFX6-NEXT:    v_readfirstlane_b32 s1, v1
; GFX6-NEXT:    v_readfirstlane_b32 s2, v2
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: abs_vgpr_v3i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v3, 0
; GFX8-NEXT:    v_sub_u16_e32 v2, 0, v0
; GFX8-NEXT:    v_sub_u16_sdwa v3, v3, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_1
; GFX8-NEXT:    v_sub_u16_e32 v4, 0, v1
; GFX8-NEXT:    v_max_i16_e32 v2, v0, v2
; GFX8-NEXT:    v_max_i16_sdwa v0, v0, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX8-NEXT:    v_max_i16_e32 v1, v1, v4
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: abs_vgpr_v3i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_pk_sub_i16 v2, 0, v0
; GFX10-NEXT:    v_sub_nc_u16 v3, 0, v1
; GFX10-NEXT:    v_pk_max_i16 v0, v0, v2
; GFX10-NEXT:    v_max_i16 v1, v1, v3
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %res = call <3 x i16> @llvm.abs.v3i16(<3 x i16> %arg, i1 false)
  ret <3 x i16> %res
}
