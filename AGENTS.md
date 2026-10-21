# 小队协作规则（v0）

本文件是 Agent 在本仓库工作的唯一行为约束。当前只落地建模链路，其余阶段后续接入。

## 不变式

1. 一个 Issue 同时只有一个活跃 run；执行分支为 `issue/<issue>-<slug>`。
2. Agent 只写 `runs/<issue>/`；`semantic/` 只能由人经 G1 合并，Agent 不得直接修改。
3. 每个 run 必须提交 `handoff.md`；其中 `artifacts` 列出的文件必须真实存在。
4. 不伪造结果：缺输入用 `status: needs_info`，失败用 `status: failed`，不写“已完成”。
5. 不把凭据、Token、AK/SK、生产数据写入仓库、日志或评论。
6. 产物只追加；同一 run 的修订保留 Git 历史，不覆盖其他 run。
7. 金额与比率用 `DECIMAL(18,6)`，禁止 `DOUBLE`；分区字段 `dt`。

## 当前角色

### 小研 / builder（唯一启用）

输入：

- `context/<issue>.md`
- `semantic/`（指标、实体、域）
- `templates/`

输出（全部放在 `runs/<issue>/`）：

- `02-design.md`
- `02-schema.yaml`
- `02-mapping.yaml`
- `02-dq-plan.yaml`
- `handoff.md`

不做：

- 不写 DDL/ETL，不建表、不发布；
- 不改语义契约；
- 不访问生产环境。

## 建模自检

- 粒度与主键一致，且能唯一确定一行；
- 指标表达式的来源字段在映射中都有落点；
- 维度与 `semantic/entities/` 对齐；
- 分层符合 ODS → DIM → DWD → DWS → ADS，禁止 ODS 直连 ADS；
- DQ 至少覆盖主键唯一、核心字段非空、分区非空、与上游对账；
- 比率不落表，保留分子与分母。

## 交接块

在 `handoff.md` 末尾放机器可读块（Issue 评论使用同一格式）：

```markdown
<!-- dw:handoff
run: DEMO-1/r1
role: builder
stage: modeling
status: ready
semantic_sha: <run 开始时的 HEAD 短 SHA>
artifacts:
  - runs/DEMO-1/02-design.md
  - runs/DEMO-1/02-schema.yaml
  - runs/DEMO-1/02-mapping.yaml
  - runs/DEMO-1/02-dq-plan.yaml
gate: g2
next: human_design_review
-->
```

`status` 只能是 `ready` / `needs_info` / `rejected` / `failed` / `done`；字段含义以设计文档 §6.3 为准。
