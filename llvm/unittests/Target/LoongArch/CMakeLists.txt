include_directories(
  ${LLVM_MAIN_SRC_DIR}/lib/Target/LoongArch
  ${LLVM_BINARY_DIR}/lib/Target/LoongArch
  )

set(LLVM_LINK_COMPONENTS
  CodeGen
  CodeGenTypes
  Core
  LoongArchCodeGen
  LoongArchDesc
  LoongArchInfo
  Instrumentation
  MC
  MIRParser
  SelectionDAG
  Support
  Target
  TargetParser
  )

add_llvm_target_unittest(LoongArchTests
  InstSizes.cpp
  MCInstrAnalysisTest.cpp
  )
