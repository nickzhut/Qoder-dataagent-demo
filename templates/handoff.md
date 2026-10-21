# 交接：<issue> / <stage>

## 结论

<!-- 一句话结论：ready / needs_info / failed，以及原因 -->

## 做了什么

<!-- 本 run 的输入、关键判断、产物 -->

## 待确认

<!-- 需要人或其他角色确认的问题；没有则写“无” -->

## 产物

- `runs/<issue>/02-design.md`
- `runs/<issue>/02-schema.yaml`
- `runs/<issue>/02-mapping.yaml`
- `runs/<issue>/02-dq-plan.yaml`

<!-- dw:handoff
run: <issue>/r1
role: builder
stage: modeling
status: ready
semantic_sha: <HEAD 短 SHA>
artifacts:
  - runs/<issue>/02-design.md
  - runs/<issue>/02-schema.yaml
  - runs/<issue>/02-mapping.yaml
  - runs/<issue>/02-dq-plan.yaml
gate: g2
next: human_design_review
-->
