# Qoder DataAgent Demo

用版本化语义契约驱动、以 Agent 小队交付的离线数据开发演示仓库。

- 当前阶段：Phase 0「走通一条」，只启用建模链路。
- 数据：全部为合成零售数据，不含生产数据、客户数据或凭据。
- 事实源：Git 保存语义与交付证据；Qoder Project 保存 Issue 状态与人工闸门。
- 示例 Issue 键：`DEMO-1`（中性命名，可映射到控制面的实际 Issue）。

## 目录

| 路径 | 用途 |
| --- | --- |
| `AGENTS.md` | 小队协作与交接规则，Agent 的唯一行为约束 |
| `context/` | 每个 Issue 的输入：业务问题、口径、验收标准 |
| `semantic/` | 指标与实体契约，Agent 的事实源 |
| `templates/` | 交付物模板，保证产物可校验 |
| `runs/` | 每个 Issue 的交付产物，只追加不覆盖 |

## 第一条链路（V1）

1. Agent 读取 `context/DEMO-1.md` 和 `semantic/`；
2. 以小研（builder）身份产出 `runs/DEMO-1/02-design.md`、`02-schema.yaml`、`02-mapping.yaml`、`02-dq-plan.yaml`；
3. 生成 `runs/DEMO-1/handoff.md`，引用上述文件；
4. 编排器校验文件存在、YAML 可解析、指标与表契约一致；
5. 不修改 `semantic/`，不产出 DDL/ETL，不访问生产。

通过标准：四件套齐全且可解析，`handoff.md` 的 artifact 路径全部存在，语义引用无悬空。

## 约定

- 分支：`issue/<issue>-<slug>`，例如 `issue/DEMO-1-shop-sales-daily`；
- 金额与比率 `DECIMAL(18,6)`，禁止 `DOUBLE`；
- 分区字段 `dt`，格式 `yyyy-MM-dd`；
- 一 Issue 同一时刻只有一个活跃 run；
- 不提交 `.env`、Token、AK/SK 或任何生产数据。
